module Stall
  module Checkout
    class PaymentReturnCheckoutStep < Stall::Checkout::Step
      include Stall::CartHelper
      include Stall::ArchivedPaidCartHelper

      def prepare
        if archivable_cart?(cart)
          archive_paid_cart_cookie(cart.identifier)
        end
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
