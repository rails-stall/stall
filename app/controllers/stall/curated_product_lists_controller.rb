module Stall
  class CuratedProductListsController < Stall::ApplicationController
    include ProductsSearch

    def show
      @curated_product_list = CuratedProductList.friendly.find(params[:id])
      search_products_among(@curated_product_list.products)

      # Also select curated list product positions to allow distinct call to
      # work when ordering results by position
      @products = @products.select('stall_products.*, stall_curated_list_products.position')

      add_breadcrumb(@curated_product_list)
    end
  end
end
