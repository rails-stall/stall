module Stall
  class LineItemsController < Stall::ApplicationController
    def create
      service = Stall.config.service_for(:add_to_cart).new(cart, line_item_params)

      if service.call
        @quantity = params[:line_item][:quantity].to_i
        @line_item = service.line_item
        render partial: 'added'
      else
        @line_item = service.line_item
        render partial: 'add_error'
      end
    end

    private

    def line_item_params
      params.require(:line_item).permit(:sellable_type, :sellable_id, :quantity)
    end

    def cart
      @cart ||= Cart.find_by_token(params[:cart_id])
    end
  end
end
