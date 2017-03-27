module Stall
  class CuratedProductListsController < Stall::ApplicationController
    def show
      @curated_product_list = CuratedProductList.friendly.find(params[:id])

      @search = @curated_product_list.products.ransack(params[:search])
      @products = @search.result
      @filterable_products = @curated_product_list.products
    end
  end
end
