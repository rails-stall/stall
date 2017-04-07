module Stall
  module ProductsSearch
    def search_products_among(products)
      @filterable_products = products
      @search = Stall.config.service_for(:products_search).new(@filterable_products, params)
      @products = @search.records.page(params[:page])
    end
  end
end
