module Stall
  class PaymentNotificationService < Stall::BaseService
    attr_reader :request

    def initialize(request)
      @request = request
    end

    def call
      gateway.process_payment_for(request)
    end

    def rendering_options
      gateway.rendering_options
    end

    private

    def gateway
      @gateway ||= gateway_class.new(cart)
    end

    def gateway_class
      @gateway_class ||= Stall::Payments.gateways[request.params[:gateway]]
    end

    def cart
      @cart ||= Cart.find(gateway_class.cart_id_from(request))
    end
  end
end
