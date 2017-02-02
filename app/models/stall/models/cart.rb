module Stall
  module Models
    module Cart
      extend ActiveSupport::Concern

      included do
        include Stall::Addressable
        include Stall::Payable
        include Stall::Shippable
        include Stall::Adjustable

        attr_accessor :terms
      end

      def total_weight
        line_items.reduce(0) do |total, line_item|
          total + (line_item.weight || Stall.config.default_product_weight)
        end
      end

      def active?
        !paid?
      end
    end
  end
end
