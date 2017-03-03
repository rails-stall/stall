module Stall
  class ProductFiltersBuilder
    attr_reader :products

    def initialize(products)
      @products = products
    end

    def filters
      properties.map do |property|
        ProductPropertyFilter.new(property, products)
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

  class ProductPropertyFilter
    attr :property, :products

    def initialize(property, products)
      @property = property
      @products = products
    end

    def name
      property.name.parameterize
    end

    def param
      :variants_property_values_id_in
    end

    def collection
      property.property_values
    end

    def rendering_options(options)
      {
        partial: 'stall/products/filters/property_filter',
        locals: { filter: self, property: property }
      }.deep_merge(options)
    end
  end
end
