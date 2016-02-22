module Stall
  module Shipping
    class Calculator
      attr_reader :cart, :config

      def initialize(cart, config)
        @cart = cart
        @config = config
      end

      def available?
        raise NoMethodError,
          'Shipping calculators must implement the #available? method ' \
          'to allow filtering available shipping methods'
      end

      def price
        raise NoMethodError,
          'Shipping calculators must implement the #price method and return ' \
          'the actual shipping price for the given cart'
      end

      def eot_price
        price / (1 + (vat_rate / 100.0))
      end

      def vat_rate
        Stall.config.vat_rate
      end

      # Register a calculator from inside the class.
      #
      # This is useful for registering the calculator direclty in the class
      # body, but is not suited for "auto-loaded" classes because of Rails'
      # class unloading behavior
      #
      def self.register(name)
        Stall.config.shipping.register_calculator(name, self)
      end

      # Fetch a shipping calculator from a shipping method or a shipping
      # method identifier
      #
      def self.for(shipping_method)
        identifier = case shipping_method
        when String, Symbol then shipping_method.to_s
        else shipping_method.identifier
        end

        name = Stall::Shipping.calculators[identifier]
        String === name ? name.constantize : name
      end

      private

      def address
        cart.shipping_address || cart.billing_address
      end
    end
  end
end
