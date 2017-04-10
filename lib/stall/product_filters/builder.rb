module Stall
  module ProductFilters
    class Builder
      attr_reader :products, :options

      def initialize(products, options = {})
        @products = products
        @options = options
      end

      def filters
        [category_filter, manufacturer_filter, price_filter] + properties_filters
      end

      def category_filter
        CategoryFilter.new(products, options_for(:category)) if enabled?(:category)
      end

      def manufacturer_filter
        ManufacturerFilter.new(products, options_for(:manufacturer)) if enabled?(:manufacturer)
      end

      def price_filter
        PriceFilter.new(products, options_for(:price)) if enabled?(:price)
      end

      def properties_filters
        if enabled?(:property)
          properties.map do |property|
            property_options = options_for(:property, property: property)
            PropertyFilter.new(products, property_options)
          end
        else
          []
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
        .distinct
      end

      def options_for(filter_name, overrides = {})
        (options[filter_name] || {}).deep_dup.merge(overrides)
      end

      def enabled?(filter_name)
        options[filter_name] != false
      end
    end
  end
end
