module Stall
  module ProductsHelper
    def product_path(*args)
      if @curated_product_list
        curated_product_list_product_path(@curated_product_list, *args)
      elsif @manufacturer
        manufacturer_product_path(@manufacturer, *args)
      else
        Rails.application.routes.url_helpers.product_path(*args)
      end
    end
  end
end
