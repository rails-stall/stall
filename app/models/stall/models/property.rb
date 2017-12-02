module Stall
  module Models
    module Property
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_properties'

        has_many :property_values, -> { ordered },
                                   dependent: :destroy,
                                   inverse_of: :property
        accepts_nested_attributes_for :property_values, allow_destroy: true

        has_many :variant_property_values, through: :property_values
        has_many :variants, through: :variant_property_values

        validates :name, presence: true
      end
    end
  end
end
