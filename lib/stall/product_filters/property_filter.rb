module Stall
  module ProductFilters
    class PropertyFilter < BaseFilter
      attr :property

      def initialize(products, property)
        super(products)
        @property = property
      end

      def name
        property.name.parameterize
      end

      def label
        property.name
      end

      def param
        :variants_property_values_id_in
      end

      def collection
        property.property_values
      end

      def partial_locals
        { filter: self, property: property }
      end
    end
  end
end
