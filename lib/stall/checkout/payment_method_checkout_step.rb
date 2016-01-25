module Stall
  module Checkout
    class PaymentMethodCheckoutStep < Stall::Checkout::Step
      def prepare
        cart.build_payment unless cart.payment
      end
    end
  end
end
