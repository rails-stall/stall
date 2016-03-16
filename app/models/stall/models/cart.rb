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

        has_many :adjustments, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :adjustments

        after_save :ensure_reference, on: :create
      end

      def subtotal
        price = line_items.map(&:price).sum
        price = Money.new(price, currency) unless Money === price
        price
      end

      def eot_subtotal
        line_items.map(&:eot_price).sum
      end

      def total_weight
        line_items.reduce(0) do |total, line_item|
          total + (line_item.weight || Stall.config.default_product_weight)
        end
      end

      def checkoutable?
        line_items.length > 0
      end

      private

      def items
        items = line_items.to_a
        items << shipment if shipment
        items += adjustments.to_a
        items
      end

      def ensure_reference
        unless reference.present?
          reference = [Time.now.strftime('%Y%m%d'), ('%05d' % id)].join('-')
          self.reference = reference
          save(validate: false)
        end
      end

      module ClassMethods
        def find_by_reference(reference)
          where("data->>'reference' = ?", reference).first
        end
      end
    end
  end
end
