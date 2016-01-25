module Stall
  module Checkout
    class ShippingMethodCheckoutStep < Stall::Checkout::Step
      def prepare
        cart.build_shipment unless cart.shipment
      end

      def process
        super
        calculate_shipping_fee!
      end

      private

      def calculate_shipping_fee!
        Stall::ShippingFeeCalculatorService.new(cart).call
      end
    end
  end
end
