module Stall
  class ProductsController < Stall::ApplicationController
    include ProductsSearch
    include ProductsBreadcrumbs

    def index
      search_products_among(Product.all)

      add_breadcrumb :products
    end

    def show
      @product = Product.friendly.includes(
        variants: [variant_property_values: [property_value: :property]]
      ).find(params[:id])

      add_product_breadcrumbs
    end
  end
end
