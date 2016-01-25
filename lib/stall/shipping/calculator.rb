module Stall
  module Shipping
    class Calculator
      attr_reader :cart, :config

      def initialize(cart, config)
        @cart = cart
        @config = config
      end

      def available_for?(address)
        raise NoMethodError,
          'Shipping calculators must implement the #available_for? method ' \
          'to allow filtering available shipping methods'
      end

      def price
        raise NoMethodError,
          'Shipping calculators must implement the #price method and return ' \
          'the actual shipping price for the given cart'
      end

      def self.register(name)
        Stall::Shipping.calculators[name] = self
      end
    end
  end
end
