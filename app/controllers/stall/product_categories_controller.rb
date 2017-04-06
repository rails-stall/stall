module Stall
  class ProductCategoriesController < Stall::ApplicationController
    def show
      @product_category = ProductCategory.friendly.find(params[:id])

      @search = Stall.config.service_for(:products_search).new(@product_category.products, params)
      @products = @search.records
      @filterable_products = @product_category.products
    end
  end
end
