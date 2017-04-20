module Stall
  class ManufacturersController < Stall::ApplicationController
    include ProductsSearch

    def show
      @manufacturer = Manufacturer.friendly.find(params[:id])
      search_products_among(@manufacturer.products)

      add_breadcrumb(@manufacturer)
    end
  end
end
