module Stall
  module Models
    module Shipment
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_shipments'

        include Stall::Priceable

        belongs_to :cart
        belongs_to :shipping_method

        monetize :eot_price_cents, :price_cents,
                 with_model_currency: :currency, allow_nil: true

        validates :cart, :shipping_method, presence: true
      end

      def currency
        cart.try(:currency) || Money.default_currency
      end
    end
  end
end
