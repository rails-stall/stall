module Stall
  module Checkout
    class PaymentReturnCheckoutStep < Stall::Checkout::Step
      include Stall::CartHelper

      def prepare
        remove_cart_from_session(cart.identifier)
      end
    end
  end
end
