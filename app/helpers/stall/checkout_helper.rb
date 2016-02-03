module Stall
  module CheckoutHelper
    def step_path(cart)
      checkout_step_path(cart.wizard.route_key, cart)
    end

    def available_shipping_methods_for(cart)
      Stall::ShippingMethod.order('stall_shipping_methods.name ASC')
        .select do |shipping_method|
          calculator_class = Stall::Shipping::Calculator.for(shipping_method)

          unless calculator_class
            raise "No calculator found for the shipping method : " +
                  "#{ shipping_method.name } " +
                  "(#{ shipping_method.identifier }). " +
                  "Please remove the Stall::ShippingMethod with id " +
                  "#{ shipping_method.id } or create the associated " +
                  "calculator with `rails g stall:shipping:calculator " +
                  "#{ shipping_method.identifier }`"
          end

          calculator = calculator_class.new(cart, shipping_method)
          calculator.available?
        end
    end
  end
end
