module Stall
  module Shipping
    class Config
      # This mehtod allows for registering an in-app calculator that can be
      # auto loaded without having to explicitly require it
      #
      # Use a string representing the calculator name if the target class is
      # auto-loaded by Rails
      #
      def register_calculator(name, calculator)
        Stall::Shipping.calculators[name] = calculator

        ShippingMethod.where(identifier: name).first_or_create do |method|
          method.name = name.to_s.humanize
        end
      end

      def configure
        yield config
      end

      def method_missing(name, *args)
        if (calculator = Stall::Shipping.calculators[name])
          calculator
        else
          super
        end
      end
    end
  end
end
