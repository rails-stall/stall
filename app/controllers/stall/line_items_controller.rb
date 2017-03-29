module Stall
  class LineItemsController < Stall::ApplicationController
    def create
      service = Stall.config.service_for(:add_to_cart).new(cart, params)

      if service.call
        @quantity = params[:line_item][:quantity].to_i
        @line_item = service.line_item
        @widget_partial = render_to_string(partial: 'stall/carts/widget', locals: { cart: cart })
        render partial: 'added'
      else
        @line_item = service.line_item
        render partial: 'add_error'
      end
    end

    private

    def cart
      @cart ||= ProductList.find_by_token(params[:cart_id]) || current_cart
    end
  end
end
