module Stall
  class LineItem < ActiveRecord::Base
    belongs_to :sellable, polymorphic: true

    validates :name, :unit_price, :unit_eot_price, :vat_rate, :price, :quantity,
              :eot_price, :sellable, presence: true

    validates :unit_price, :unit_eot_price, :vat_rate, :price, :eot_price,
              numericality: true

    validates :quantity, numericality: { greater_than: 0 }

    validate  :stock_availability

    before_validation :refresh_total_prices

    def like?(other)
      [:sellable_id, :sellable_type].all? do |property|
        public_send(property) == other.public_send(property)
      end
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
