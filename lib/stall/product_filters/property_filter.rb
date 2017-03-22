module Stall
  module ProductFilters
    class PropertyFilter < BaseFilter
      attr :property

      def initialize(products, property)
        super(products)
        @property = property
      end

      def available?
        collection.count > 1
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
        @collection ||= property.property_values.joins(variants: :product)
          .where(stall_products: { id: products.select(:id) })
          .uniq
      end

      def partial_locals
        { filter: self, property: property }
      end
    end
  end
end
