module Stall
  module AddToCartHelper
    def add_to_cart_form_for(sellable, cart: nil)
      render partial: 'stall/cart_line_items/form', locals: {
        cart: (cart || current_cart),
        line_item: LineItem.new(sellable: sellable),
        product: sellable
      }
    end
  end
end
