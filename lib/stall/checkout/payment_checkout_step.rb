module Stall
  module Checkout
    class PaymentCheckoutStep < Stall::Checkout::Step
      # By default, the payment processing occurs in the background and, for
      # some of the payment gateways, can be run asynchronously. Thus, we don't
      # need to make any verification here, and just let the user go to the next
      # step if we're passed the :succeeded param.
      #
      # This could be overriden if the payment processing needs to occur
      # synchronously at this point, you can override this method to process
      # it.
      #
      def process
        return true if params[:succeeded]
      end

      # When we access this step after a payment to validate the step, the cart
      # is "inactive", so we force processing the cart.
      #
      def allow_inactive_carts?
        !!params[:succeeded]
      end
    end
  end
end
