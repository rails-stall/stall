module Stall
  module Models
    module LineItem
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_line_items'

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

        before_validation :refresh_total_prices
      end

      def like?(other)
        [:sellable_id, :sellable_type].all? do |property|
          public_send(property) == other.public_send(property)
        end
      end

      def currency
        product_list.try(:currency) || Money.default_currency
      end

      def vat
        price - eot_price
      end

      private

      # TODO : Stocks availibility handling
      def stock_availability
      end

      def refresh_total_prices
        self.eot_price = unit_eot_price * quantity if unit_eot_price && quantity
        self.price     = unit_price     * quantity if unit_price     && quantity
      end
    end
  end
end
