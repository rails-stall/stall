module Stall
  class CartUpdateService < Stall::BaseService
    attr_reader :cart, :params

    def initialize(cart, params)
      @cart = cart
      @params = params
    end

    def call
      cart.update(params).tap do |saved|
        return false unless saved

        # Recalculate shipping fee if available for calculation to ensure
        # that the fee us always up to date when displayed to the customer
        shipping_fee_service.call if shipping_fee_service.available?

        # Recalculate the credit usage amount if already used to avoid negative
        # cart totals
        credit_usage_service.call if credit_usage_service.credit_used?
      end
    end

    private

    def shipping_fee_service
      @shipping_fee_service ||= Stall.config.service_for(:shipping_fee_calculator).new(cart)
    end

    def credit_usage_service
      @credit_usage_service ||= Stall.config.service_for(:credit_usage).new(cart)
    end
  end
end
