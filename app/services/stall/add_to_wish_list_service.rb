module Stall
  class AddToWishListService < Stall::AddToProductListService
    alias_method :wish_list, :product_list

    def call
      return false unless line_item.valid?
      wish_list.line_items << line_item unless assemble_identical_line_items
      wish_list.save
    end

    def add(variant)
      @sellable = variant
      @quantity = 1
      call
    end
  end
end
