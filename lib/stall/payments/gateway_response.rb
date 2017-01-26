module Stall
  module Payments
    class GatewayResponse
      attr_reader :request

      def initialize(request)
        @request = request
      end

      def rendering_options
        { nothing: true }
      end

      def success?
        false
      end

      def notify
        cart.payment.pay! if success?
      end

      def valid?
        false
      end

      def cart
        fail NotImplementedError, 'Stall::Payments::GatewayResponse ' \
          'subclasses should override the #cart method to allow the default ' \
          'payment processing.'
      end
    end
  end
end
