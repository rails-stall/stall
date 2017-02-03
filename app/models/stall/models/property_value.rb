module Stall
  module Models
    module PropertyValue
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_property_values'

        acts_as_orderable

        belongs_to :property

        has_many :variant_property_values, dependent: :destroy,
                                           inverse_of: :property_value
        has_many :variants, through: :variant_property_values

        validates :property, :value, presence: true

        alias_attribute :name, :value
      end
    end
  end
end
