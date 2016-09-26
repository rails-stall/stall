module Stall
  module Checkout
    class PaymentCheckoutStep < Stall::Checkout::Step
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
