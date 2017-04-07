module Stall
  class ManufacturersController < ApplicationController
    include ProductsSearch

    def show
      @manufacturer = Manufacturer.friendly.find(params[:id])
      search_products_among(@manufacturer.products)
    end
  end
end
