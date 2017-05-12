module Stall
  class WishListLineItemsController < Stall::LineItemsController
    include Stall::AddToWishListHelper

    def create
      if !service.line_item_params? && (product_id = params[:product_id]).present?
        product = Product.find(product_id)

        if product.variants.length > 1
          form = render_to_string(
            partial: 'stall/wish_list_line_items/form', locals: {
              wish_list: product_list, line_item: LineItem.new, product: product
            }
          )

          add_to_wish_list_button(product, {
            wish_list: product_list, popover_content: form
          })
        else
          service.add(product.variants.first)
          add_to_wish_list_button(product, wish_list: product_list)
        end
      else
        super do |valid|
          if (product = @line_item.sellable.try(:product))
            add_to_wish_list_button(product, wish_list: product_list)
          end
        end
      end
    end

    def destroy
      line_item = product_list.line_items.find(params[:id])
      product = line_item.sellable.try(:product)
      product_list.line_items.destroy(line_item)

      if product
        add_to_wish_list_button(product, wish_list: product_list)
      end
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
