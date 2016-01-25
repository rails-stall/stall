module Stall
  module Shipping
    class FreeShippingCalculator < Stall::Shipping::Calculator
      register :free_shipping

      class_attribute :available

      def price
        0
      end

      def available_for?(address)
        if Array === available
          available.include?(address.country)
        elsif Proc === available
          available.call(address)
        else
          true
        end
      end
    end
  end
end
