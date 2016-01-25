module Stall
  class Shipment < ActiveRecord::Base
    belongs_to :cart
    belongs_to :shipping_method

    monetize :eot_price_cents, :price_cents,
             with_model_currency: :currency, allow_nil: true

    validates :cart, :shipping_method, presence: true

    def currency
      cart.try(:currency) || Money.default_currency
    end
  end
end
