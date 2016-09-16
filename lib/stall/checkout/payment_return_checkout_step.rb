module Stall
  module Checkout
    class PaymentReturnCheckoutStep < Stall::Checkout::Step
      include Stall::CartHelper

      def prepare
        remove_cart_from_cookies(cart.identifier)
      end

      # When we access this step, the cart is "inactive", since it is paid, so
      # we force processing the cart.
      #
      def allow_inactive_carts?
        true
      end
    end
  end
end
