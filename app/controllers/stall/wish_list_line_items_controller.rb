module Stall
  class WishListLineItemsController < Stall::LineItemsController
    def destroy
      product_list.line_items.find(params[:id]).destroy
    end

    private

    def product_list
      @product_list ||= ProductList.find_by_token(params[:cart_id]) || current_wish_list
    end

    def service
      @service ||= Stall.config.service_for(:add_to_wish_list).new(product_list, params)
    end
  end
end
