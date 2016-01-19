module Stall
  module AddToCartHelper
    def add_to_cart_form_for(sellable, cart: nil)
      render partial: 'stall/cart/line_item_form', locals: {
        cart: (cart || current_cart),
        line_item: Stall::LineItem.new(sellable: sellable)
      }
    end
  end
end
