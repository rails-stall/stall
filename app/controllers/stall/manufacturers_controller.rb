module Stall
  class ManufacturersController < ApplicationController
    def show
      @manufacturer = Manufacturer.friendly.find(params[:id])

      @search = Stall.config.service_for(:products_search).new(@manufacturer.products, params)
      @products = @search.records
      @filterable_products = @manufacturer.products
    end
  end
end
