module Stall
  module AddToWishListHelper
    def add_to_wish_list_button(wish_list = current_wish_list)
      render partial: 'stall/wish_list_line_items/button', locals: {
        cart: wish_list
      }
    end
  end
end
