module Stall
  module Models
    module Cart
      extend ActiveSupport::Concern

      included do
        include Stall::Addressable
        include Stall::Payable

        has_one :shipment, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :shipment

        has_many :adjustments, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :adjustments
      end

      def total_weight
        line_items.reduce(0) do |total, line_item|
          total + (line_item.weight || Stall.config.default_product_weight)
        end
      end

      private

      def items
        items = line_items.to_a
        items << shipment if shipment
        items += adjustments.to_a
        items
      end
    end
  end
end
