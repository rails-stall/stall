module Stall
  module ProductsFiltersHelper
    # Display various filters for the given products including :
    #
    #   - Product categories filters (:category)
    #   - Manufacturer filters (:manufacturer)
    #   - Price filter (:price)
    #   - Properties filters (:property)
    #
    # Those filters allow automatically searching into the provided products
    # and should only be provided a list of prodcts that can be displayed
    # for the current products list. e.g. for the brands#show products list,
    # we pass the filters all the products from the manufacturer.
    #
    # In Stall, it is handled by the @filterable_products instance variables
    # from the ProductCategoriesController, ManufacturersController and
    # ProductsController.
    #
    # By default, all available filters (which contains possible results) are
    # shown. If you need to remove a filter, you can pass an option with
    # its name as false. The following would remove the category filter :
    #
    #   product_filters_for(@filterable_products, category: false)
    #
    # If, at the opposite, you need to force the display of a certain filter
    # even if there's no results available, you can do the following :
    #
    #   product_filters_for(@filterable_products, category: { force: true })
    #
    def product_filters_for(products, options = {})
      Stall::ProductFilters::Builder.new(products, options).filters.select(&:available?)
    end
  end
end
