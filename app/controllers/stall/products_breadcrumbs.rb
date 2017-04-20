module Stall
  module ProductsBreadcrumbs
    private

    def add_product_breadcrumbs
      add_product_category_breadcrumbs(@product.product_category)
      add_breadcrumb(@product)
    end

    def add_product_category_breadcrumbs(product_category)
      product_category.self_and_ancestors.reverse.each do |category|
        add_breadcrumb category
      end if product_category
    end
  end
end
