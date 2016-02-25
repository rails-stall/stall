module Stall
  class PaymentNotificationService < Stall::BaseService
    attr_reader :request, :gateway_identifier

    def initialize(gateway_identifier, request)
      @gateway_identifier = gateway_identifier
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
      @gateway_class ||= Stall::Payments.gateways[gateway_identifier]
    end

    def cart
      @cart ||= Cart.find(gateway_class.cart_id_from(request))
    end
  end
end
