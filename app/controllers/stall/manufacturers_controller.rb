module Stall
  class ManufacturersController < ApplicationController
    def show
      @manufacturer = Manufacturer.friendly.find(params[:id])
      @filterable_products = @manufacturer.products
      @search = Stall.config.service_for(:products_search).new(@filterable_products, params)
      @products = @search.records
    end
  end
end
