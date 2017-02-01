module Stall
  class PaymentNotificationService < Stall::BaseService
    class UnknownNotificationError < StandardError; end

    attr_reader :gateway_identifier, :request

    def initialize(gateway_identifier, request)
      @gateway_identifier = gateway_identifier
      @request = request
    end

    def call
      if gateway_response.valid?
        validate_cart! if gateway_response.process
      else
        raise UnknownNotificationError,
              "The payment notification request does not seem to come from " +
              "the \"#{ gateway_identifier }\" gateway."
      end
    end

    def rendering_options
      gateway_response.rendering_options
    end

    private

    def validate_cart!
      service = Stall.config.service_for(:cart_payment_validation)
      service.new(gateway_response.cart).call
    end

    def gateway_class
      @gateway_class ||= Stall::Payments.gateways[gateway_identifier]
    end

    def gateway_response
      @gateway_response ||= gateway_class.response(request)
    end
  end
end
