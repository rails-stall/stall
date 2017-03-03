module Stall
  class ProductCategoriesController < Stall::ApplicationController
    def show
      @product_category = ProductCategory.friendly.find(params[:id])
      @products = @product_category.products
    end
  end
end
