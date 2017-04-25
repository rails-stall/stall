module Stall
  module Models
    module LineItem
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_line_items'

        include Stall::Priceable

        store_accessor :data, :weight

        monetize :unit_eot_price_cents, :unit_price_cents,
                 :eot_price_cents, :price_cents,
                 with_model_currency: :currency, allow_nil: true

        belongs_to :sellable, polymorphic: true
        belongs_to :product_list

        validates :name, :unit_price, :unit_eot_price, :vat_rate, :price, :quantity,
                  :eot_price, :sellable, presence: true

        validates :unit_price, :unit_eot_price, :vat_rate, :price, :eot_price,
                  numericality: true

        validates :quantity, numericality: { greater_than: 0 }

        validate  :stock_availability

        before_validation :restore_valid_quantity
        before_validation :refresh_total_prices
        before_validation :refresh_weight

        scope :ordered, -> { order(created_at: :asc) }
      end

      def like?(other)
        [:sellable_id, :sellable_type].all? do |property|
          public_send(property) == other.public_send(property)
        end
      end

      def currency
        product_list.try(:currency) || Money.default_currency
      end

      def weight
        read_store_attribute(:data, :weight).presence || Stall.config.default_product_weight
      end

      def total_weight
        weight * quantity
      end

      private

      # TODO : Stocks availibility handling
      def stock_availability
      end

      def refresh_total_prices
        self.eot_price = unit_eot_price * quantity if unit_eot_price && quantity
        self.price     = unit_price     * quantity if unit_price     && quantity
      end

      # Ensures that a quantity set to 0 to an existing line item doesn't return
      # an error.
      def restore_valid_quantity
        if persisted? && quantity && (quantity < 1) && quantity_changed?
          restore_quantity!
        end
      end

      def refresh_weight
        self.weight = sellable.weight if sellable.respond_to?(:weight)
      end
    end
  end
end
