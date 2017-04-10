module Stall
  module ProductFilters
    class PropertyFilter < BaseFilter
      attr :property

      def initialize(*)
        super
        @property = options[:property]
      end

      def available?
        @available ||= (options[:force] || collection.count > 1)
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
          .distinct
      end

      def partial_locals
        { filter: self, property: property }
      end
    end
  end
end
