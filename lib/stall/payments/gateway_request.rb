module Stall
  module Payments
    class GatewayRequest
      attr_reader :cart

      def initialize(cart)
        @cart = cart
      end

      def payment_form_partial_path
        nil
      end
    end
  end
end
