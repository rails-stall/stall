module Stall
  module Models
    module Variant
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_variants'

        include Stall::Sellable

        belongs_to :product

        monetize :price_cents, with_model_currency: :currency, allow_nil: false

        delegate :name, :image, :image?, :vat_rate, to: :product, allow_nil: true

        def currency
          @currency ||= Money::Currency.new(Stall.config.default_currency)
        end
      end
    end
  end
end
