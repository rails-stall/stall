module Stall
  class ProductsController < Stall::ApplicationController
    include ProductsSearch
    include ProductsBreadcrumbs

    before_action :load_parent_data

    def index
      search_products_among(Product.all)

      add_breadcrumb :products
    end

    def show
      @product = Product.friendly.includes(
        variants: [variant_property_values: [property_value: :property]]
      ).find(params[:id])

      add_product_breadcrumbs
    end

    private

    def load_parent_data
      if params[:curated_product_list_id]
        @curated_product_list = CuratedProductList.find(params[:curated_product_list_id])
      elsif params[:manufacturer_id]
        @manufacturer = Manufacturer.find(params[:manufacturer_id])
      end
    end
  end
end
