module Stall
  module AddToWishListHelper
    def add_to_wish_list_button(product, variant: nil, wish_list: current_wish_list, popover_content: nil)
      included = wish_list.includes_product?(product)

      url = if included
        line_item = wish_list.line_item_for_product(product)
        wish_list_line_item_path(current_wish_list, line_item)
      else
        wish_list_line_items_path(current_wish_list)
      end

      title = if included
        t('stall.wish_list_line_items.form.remove')
      else
        t('stall.wish_list_line_items.form.add')
      end

      render partial: 'stall/wish_list_line_items/button', locals: {
        product: product,
        variant: variant,
        cart: wish_list,
        included: included,
        url: url,
        title: title,
        popover_content: popover_content
      }
    end
  end
end
