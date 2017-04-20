module Stall
  class ProductCategoriesController < Stall::ApplicationController
    include ProductsSearch
    include ProductsBreadcrumbs

    def show
      @product_category = ProductCategory.friendly.find(params[:id])
      search_products_among(@product_category.all_child_products)

      add_product_category_breadcrumbs(@product_category)
    end
  end
end
