module Stall
  module ProductFilters
    class Builder
      attr_reader :products

      def initialize(products)
        @products = products
      end

      def filters
        [category_filter, manufacturer_filter, price_filter] + properties_filters
      end

      def category_filter
        CategoryFilter.new(products)
      end

      def manufacturer_filter
        ManufacturerFilter.new(products)
      end

      def price_filter
        PriceFilter.new(products)
      end

      def properties_filters
        properties.map do |property|
          PropertyFilter.new(products, property)
        end
      end

      private

      def properties
        Property.joins(
          property_values: [
            variant_property_values: [:variant]
          ]
        )
        .includes(:property_values)
        .uniq
      end
    end
  end
end
