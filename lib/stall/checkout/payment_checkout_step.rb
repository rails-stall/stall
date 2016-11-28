module Stall
  module Checkout
    class PaymentCheckoutStep < Stall::Checkout::Step
      # Determine wether the customer's payment has been validated or not.
      #
      # By default, the payment processing occurs in the background and, for
      # some of the payment gateways, can be run asynchronously. In this case,
      # the gateway should redirect here with the `:succeeded` param in the URL.
      #
      # If the payment processing occurs synchronously, the gateway overrides
      # the #synchronous_payment_notification? method, using the cart payment
      # state to determine this parameter.
      #
      def process
        if gateway.synchronous_payment_notification?
          cart.paid?
        elsif params[:succeeded]
          true
        end
      end

      # When we access this step after a payment to validate the step, the cart
      # is "inactive", so we force processing the cart.
      #
      def allow_inactive_carts?
        !!params[:succeeded]
      end

      private

      def gateway
        @gateway ||= Stall::Payments::Gateway.for(cart.payment.payment_method).new(cart)
      end
    end
  end
end
