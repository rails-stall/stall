module Stall
  class AddToCartService < Stall::AddToProductListService
    alias_method :cart, :product_list

    def call
      return false unless line_item_valid?

      cart.line_items << line_item unless assemble_identical_line_items

      cart.save.tap do |saved|
        return false unless saved

        # Recalculate shipping fee if available for calculation to ensure
        # that the fee us always up to date when displayed to the customer
        shipping_fee_service.call if shipping_fee_service.available?
      end
    end

    def line_item_valid?
      line_item.valid? && enough_stock?
    end

    def enough_stock?
      stock_service = Stall.config.service_for(:available_stocks).new
      stock_service.on_hand?(line_item)
    end

    private

    def shipping_fee_service
      @shipping_fee_service ||= Stall.config.service_for(:shipping_fee_calculator).new(cart)
    end
  end
end
