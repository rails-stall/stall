require 'digest'

module Stall
  module Payments
    class ManualPaymentGateway < Gateway
      register :manual_payment

      def self.request(cart)
        Request.new(cart)
      end

      def self.response(_request)
        Response.new(_request)
      end

      # Request and Response common helper to calculate a checksum for the
      # given token, reference and timestamp arguments with the Rails secret
      # key base as the secret salt
      #
      module ChecksumCalculator
        def calculate_checksum_for(*arguments)
          arguments << Rails.application.secrets.secret_key_base
          Digest::SHA256.hexdigest(arguments.map(&:to_s).join('|'))
        end
      end

      class Request < Stall::Payments::GatewayRequest
        include ChecksumCalculator

        delegate :token, :reference, to: :cart

        def payment_form_partial_path
          'stall/payments/manual_payment_gateway/form'
        end

        def timestamp
          @timestamp ||= (Time.now.to_f * 1000).round.to_s
        end

        def checksum
          calculate_checksum_for(token, reference, timestamp)
        end
      end

      class Response < Stall::Payments::GatewayResponse
        include ChecksumCalculator

        def rendering_options
          redirect_location =
            Stall::Payments::UrlsConfig.new(cart).payment_success_return_url

          { redirect_location: redirect_location }
        end

        def success?
          true
        end

        # To allow manual payment method we verify that the provided checksum
        # corresponds to the one we can calculate with the provided params in
        # the form.
        #
        # This avoids forging a request with `manual_payment` in the URL for
        # a cart which was not set to use this method, thus allowing people
        # to validate orders without paying them.
        #
        def valid?
          calculated_checksum = calculate_checksum_for(
            cart_params[:token], cart_params[:reference], cart_params[:timestamp]
          )
          provided_checksum = cart_params[:checksum]

          calculated_checksum == provided_checksum
        end

        def cart
          @cart ||= ProductList.find_by_token(request.params[:cart][:token])
        end

        def cart_params
          @cart_params ||= request.params[:cart]
        end
      end
    end
  end
end
