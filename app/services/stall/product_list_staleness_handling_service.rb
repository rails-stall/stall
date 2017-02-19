module Stall
  class ProductListStalenessHandlingService < Stall::BaseService
    attr_reader :cart

    def initialize(cart)
      @cart = cart
    end

    def call
      handle_line_items
    end

    private

    def handle_line_items
      cart.line_items.each do |line_item|
        if stale?(line_item)
          cart.line_items.delete(line_item)
        else
          handle_valid_line_item(line_item)
        end
      end
    end

    def handle_valid_line_item line_item
      # Override this method
    end

    def stale?(line_item)
      # The line item does not match a sellable (product deleted)
      return true unless (sellable = line_item.sellable)
      # The sellable is not published anymore
      line_item.sellable.try(:published?) == false
    end
  end
end
