module Stall
  class ProductsController < ApplicationController
    def show
      @product = Product.friendly.includes(
        variants: [variant_property_values: [property_value: :property]]
      ).find(params[:id])
    end
  end
end
