module Stall
  module Models
    module VariantPropertyValue
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_variant_property_values'

        belongs_to :property_value
        has_one :property, through: :property_value

        belongs_to :variant

        validates :property_value, :variant, presence: true
      end
    end
  end
end
