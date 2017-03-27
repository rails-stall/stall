module Stall
  class ManufacturersController < ApplicationController
    def show
      @manufacturer = Manufacturer.friendly.find(params[:id])

      @search = @manufacturer.products.ransack(params[:search])
      @products = @search.result
      @filterable_products = @manufacturer.products
    end
  end
end
