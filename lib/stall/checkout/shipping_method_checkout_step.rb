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
        service_class = Stall.config.service_for(:shipping_fee_calculator)
        service_class.new(cart).call
      end
    end
  end
end
