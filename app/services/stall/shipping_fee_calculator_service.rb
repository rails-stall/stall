module Stall
  class ShippingFeeCalculatorService < Stall::BaseService
    attr_reader :cart

    def initialize(cart)
      @cart = cart
    end

    def call
      return unless cart.shipment && cart.shipment.shipping_method

      update_price_for(cart.shipment, calculator) if calculator
    end

    def available?
      cart.line_items.length > 0 &&
        cart.try(:shipping_address) &&
          cart.try(:shipment).try(:shipping_method)
    end

    private

    def update_price_for(shipment, calculator)
      shipment.update_attributes(
        price: calculator.price,
        eot_price: calculator.eot_price,
        vat_rate: calculator.vat_rate
      )
    end

    def calculator
      @calculator ||= calculator_class && calculator_class.new(cart, cart.shipment.shipping_method)
    end

    def calculator_class
      @calculator_class ||= Stall::Shipping::Calculator.for(
        cart.shipment.shipping_method.identifier
      ) if cart.shipment.try(:shipping_method)
    end
  end
end
