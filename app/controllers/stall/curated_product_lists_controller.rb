module Stall
  class CuratedProductListsController < Stall::ApplicationController
    include ProductsSearch

    def show
      @curated_product_list = CuratedProductList.friendly.find(params[:id])
      search_products_among(@curated_product_list.products)
    end
  end
end
