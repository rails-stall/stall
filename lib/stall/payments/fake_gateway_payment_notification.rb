module Stall
  module Payments
    class FakeGatewayPaymentNotification
      attr_reader :cart

      def initialize(cart)
        @cart = cart
      end

      def params
        raise 'FakeGatewayPaymentNotification subclasses must define the ' \
              '#params method to return a valid notification params hash.'
      end

      def raw_post
        params.to_query
      end

      private

      def transaction_id
        ['FAKE', cart.reference, 0].join('-')
      end

      def gateway
        @gateway ||= gateway_class.new(cart)
      end

      def gateway_class
        @gateway_class ||= Stall::Payments::Gateway.for(cart.payment.payment_method)
      end
    end
  end
end
