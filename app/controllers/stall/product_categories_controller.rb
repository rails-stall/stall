module Stall
  class ProductCategoriesController < Stall::ApplicationController
    def show
      @product_category = ProductCategory.friendly.find(params[:id])
      @filterable_products = @product_category.all_child_products
      @search = Stall.config.service_for(:products_search).new(@filterable_products, params)
      @products = @search.records
    end
  end
end
