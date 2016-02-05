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

      def self.register(name)
        Stall::Shipping.calculators[name] = self

        ShippingMethod.where(identifier: name).first_or_create do |method|
          method.name = name.to_s.humanize
        end
      end

      def self.for(shipping_method)
        Stall::Shipping.calculators[shipping_method.identifier]
      end

      private

      def address
        cart.shipping_address || cart.billing_address
      end
    end
  end
end
