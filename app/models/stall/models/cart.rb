module Stall
  module Models
    module Cart
      extend ActiveSupport::Concern

      included do
        include Stall::Addressable

        store_accessor :data, :reference

        has_one :shipment, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :shipment

        has_one :payment, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :payment

        after_save :ensure_reference, on: :create
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
        items
      end

      def ensure_reference
        unless reference.present?
          reference = [Time.now.strftime('%Y%m%d'), ('%05d' % id)].join('-')
          self.reference = reference
          save(validate: false)
        end
      end
    end
  end
end
