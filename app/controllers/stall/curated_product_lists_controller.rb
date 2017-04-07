module Stall
  class CuratedProductListsController < Stall::ApplicationController
    def show
      @curated_product_list = CuratedProductList.friendly.find(params[:id])
      @filterable_products = @curated_product_list.products
      @search = Stall.config.service_for(:products_search).new(@filterable_products, params)
      @products = @search.records
    end
  end
end
