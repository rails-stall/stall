module Stall
  module Shipping
    class FreeShippingCalculator < Stall::Shipping::Calculator
      register :free_shipping

      class_attribute :available

      def price
        0
      end

      def available?
        case available
        when Array then address && available.include?(address.country)
        when Proc then available.call(address)
        else true
        end
      end
    end
  end
end
