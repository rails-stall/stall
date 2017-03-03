module Stall
  module ProductsFiltersHelper
    def product_filters_for(products)
      Stall::ProductFiltersBuilder.new(products).filters
    end
  end
end
