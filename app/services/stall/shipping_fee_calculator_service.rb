module Stall
  class ShippingFeeCalculatorService < Stall::BaseService
    attr_reader :cart

    def initialize(cart)
      @cart = cart
    end

    def call
      return unless cart.shipment && cart.shipment.shipping_method

      calculator_identifier = cart.shipment.shipping_method.identifier
      calculator_class = Stall::Shipping::Calculator.for(calculator_identifier)

      if calculator_class
        calculator = calculator_class.new(cart, cart.shipment.shipping_method)

        cart.shipment.update_attributes(
          price: calculator.price,
          eot_price: calculator.eot_price,
          vat_rate: calculator.vat_rate
        )
      end
    end

    def available?
      cart.line_items.length > 0 &&
      cart.try(:shipping_address) &&
      cart.try(:shipment).try(:shipping_method)
    end
  end
end
