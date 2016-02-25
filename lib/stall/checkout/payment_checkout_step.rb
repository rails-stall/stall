module Stall
  module Checkout
    class PaymentCheckoutStep < Stall::Checkout::Step
      def process
        return true if params[:succeeded]
      end
    end
  end
end
