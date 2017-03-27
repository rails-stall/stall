module Stall
  class ProductCategoriesController < Stall::ApplicationController
    def show
      @product_category = ProductCategory.friendly.find(params[:id])

      @search = @product_category.products.ransack(params[:search])
      @products = @search.result.distinct
      @filterable_products = @product_category.products
    end
  end
end
