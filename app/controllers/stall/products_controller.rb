module Stall
  class ProductsController < ApplicationController
    include ProductsSearch

    def index
      search_products_among(Product.all)
    end

    def show
      @product = Product.friendly.includes(
        variants: [variant_property_values: [property_value: :property]]
      ).find(params[:id])
    end
  end
end
