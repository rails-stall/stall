module Stall
  module Shipping
    class Config
      # This mehtod allows for registering an in-app calculator that can be
      # auto loaded without having to explicitly require it
      def register_calculator(name, calculator)
        calculator.register(name)
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
