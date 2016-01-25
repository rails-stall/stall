module Stall
  class Cart < Stall::ProductList
    include Stall::Addressable

    has_one :shipment, dependent: :destroy, inverse_of: :cart
    accepts_nested_attributes_for :shipment

    def total_weight
      line_items.reduce(0) do |total, line_item|
        total + (line_item.weight || Stall.config.default_product_weight)
      end
    end
  end
end
