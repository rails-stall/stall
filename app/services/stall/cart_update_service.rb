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
      end
    end

    private

    def shipping_fee_service
      @shipping_fee_service ||= Stall::ShippingFeeCalculatorService.new(cart)
    end
  end
end
