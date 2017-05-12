module Stall
  module Models
    module WishList
      extend ActiveSupport::Concern

      def includes_product?(product)
        line_item_for_product(product).present?
      end

      def line_item_for_product(product)
        line_items.find do |line_item|
          line_item.sellable_type == 'Variant' &&
            product.variant_ids.include?(line_item.sellable_id)
        end
      end
    end
  end
end
