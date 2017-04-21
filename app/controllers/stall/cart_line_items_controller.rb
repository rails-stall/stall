module Stall
  class CartLineItemsController < Stall::LineItemsController
    def create
      super do |success|
        if success
          @widget_partial = render_to_string(partial: 'stall/carts/widget', locals: { cart: product_list })
        end
      end
    end

    private

    def product_list
      @product_list ||= ProductList.find_by_token(params[:cart_id]) || current_cart
    end

    def service
      @service ||= Stall.config.service_for(:add_to_cart).new(product_list, params)
    end
  end
end
