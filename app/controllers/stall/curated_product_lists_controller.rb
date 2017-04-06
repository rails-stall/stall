module Stall
  class CuratedProductListsController < Stall::ApplicationController
    def show
      @curated_product_list = CuratedProductList.friendly.find(params[:id])

      @search = Stall.config.service_for(:products_search).new(@curated_product_list.products, params)
      @products = @search.records
      @filterable_products = @curated_product_list.products
    end
  end
end
