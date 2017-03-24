module Stall
  module ProductsFiltersHelper
    def product_filters_for(products)
      Stall::ProductFilters::Builder.new(products).filters.select(&:available?)
    end
  end
end
