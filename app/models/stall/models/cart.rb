module Stall
  module Models
    module Cart
      extend ActiveSupport::Concern

      included do
        include Stall::Addressable

        has_one :shipment, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :shipment

        has_one :payment, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :payment

        has_many :adjustments, dependent: :destroy, inverse_of: :cart
        accepts_nested_attributes_for :adjustments

        scope :paid, -> {
          joins(:payment).where.not(stall_payments: { paid_at: nil })
        }

        scope :finalized, -> { paid }

        scope :aborted, ->(options = {}) {
          joins('LEFT JOIN stall_payments ON stall_payments.cart_id = stall_product_lists.id')
            .where(stall_payments: { paid_at: nil })
            .older_than(options.fetch(:before, 1.day.ago))
        }
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
