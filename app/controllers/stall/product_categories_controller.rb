module Stall
  class ProductCategoriesController < Stall::ApplicationController
    include ProductsSearch

    def show
      @product_category = ProductCategory.friendly.find(params[:id])
      search_products_among(@product_category.all_child_products)
    end
  end
end
