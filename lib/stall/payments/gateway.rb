module Stall
  module Payments
    class Gateway
      TRANSACTION_ID_FORMAT = 'ESHOP-%{cart_id}-%{transaction_index}'

      attr_reader :cart

      def initialize(cart)
        @cart = cart
      end

      def self.register(name)
        Stall::Payments.gateways[name] = self
      end

      def self.cart_id_from(_request)
        raise NoMethodError,
          'Subclasses must implement the .cart_id_from(request) class method ' \
          'to allow retrieving the cart from the remote gateway notification ' \
          'request object'
      end

      def self.cart_id_from_transaction_id(transaction_id)
        transaction_id && transaction_id.split('-')[2].to_i
      end

      def process_payment_for(_request)
        raise NoMethodError,
          'Subclasses must implement the #process_payment_for(request) ' \
          'method to handle payment verifications and cart payment validation'
      end

      def transaction_id
        @transaction_id ||= begin
          unless (id = cart.payment.transaction_id)
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
        { text: nil }
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
        TRANSACTION_ID_FORMAT
          .gsub('%{cart_id}', cart.reference)
          .gsub('%{transaction_index}', ('%05d' % index))
      end
    end
  end
end
