module Stall
  module Models
    module Variant
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_variants'

        include Stall::Sellable

        belongs_to :product

        has_many :variant_property_values, dependent: :destroy,
                                           inverse_of: :variant
        accepts_nested_attributes_for :variant_property_values,
                                      allow_destroy: true,
                                      reject_if: :all_blank

        has_many :property_values, through: :variant_property_values
        has_many :properties, through: :property_values

        monetize :price_cents, with_model_currency: :currency, allow_nil: false

        delegate :name, :image, :image?, :vat_rate, to: :product, allow_nil: true

        scope :published, -> { where(published: true) }

        def currency
          @currency ||= Money::Currency.new(Stall.config.default_currency)
        end
      end
    end
  end
end
