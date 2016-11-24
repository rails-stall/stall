module Stall
  module Payments
    class Gateway
      attr_reader :cart

      def initialize(cart)
        @cart = cart
      end

      def self.register(name)
        Stall.config.payment.register_gateway(name, self)
      end

      def self.for(payment_method)
        identifier = case payment_method
        when String, Symbol then payment_method.to_s
        else payment_method.identifier
        end

        gateway = Stall::Payments.gateways[identifier]
        String === gateway ? gateway.constantize : gateway
      end

      def self.request(cart)
        raise NoMethodError,
          'Subclasses must implement the .request(cart) class method '
      end

      def self.response(_request)
        raise NoMethodError,
          'Subclasses must implement the .response(request) class method '
      end

      def transaction_id(refresh: false)
        @transaction_id ||= begin
          if refresh || !(id = cart.payment.transaction_id)
            id = next_transaction_id
            cart.payment.update_attributes(transaction_id: id)
          end

          id
        end
      end

      # Defines the arguments passed to the render call in response to the
      # automatic gateway response notification
      #
      # Most of the gateways expect some specific return, so this is to be
      # overriden by subclasses
      def rendering_options
        { nothing: false }
      end

      def payment_urls
        @payment_urls ||= Stall::Payments::UrlsConfig.new(cart)
      end

      private

      def next_transaction_id
        if (last_transaction = Payment.order("data->>'transaction_id' DESC").select(:data).first)
          if (id = last_transaction.transaction_id)
            index = id.split('-').pop.to_i + 1
            return transaction_id_for(index)
          end
        end

        transaction_id_for(1)
      end

      def transaction_id_for(index)
        transaction_id_format
          .gsub('%{cart_id}', cart.reference)
          .gsub('%{transaction_index}', ('%05d' % index))
      end

      def transaction_id_format
        'ESHOP-%{cart_id}-%{transaction_index}'
      end
    end
  end
end
