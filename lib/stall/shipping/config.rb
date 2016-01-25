module Stall
  module Shipping
    class Config
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
