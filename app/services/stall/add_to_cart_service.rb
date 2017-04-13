module Stall
  class AddToCartService < Stall::BaseService
    attr_reader :cart, :params

    def initialize(cart, params)
      @cart = cart
      @params = params
    end

    def call
      return false unless line_item_valid?

      unless assemble_identical_line_items
        cart.line_items << line_item
      end

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

    def line_item
      @line_item ||= sellable.to_line_item.tap do |line_item|
        line_item.quantity = line_item_params[:quantity]
      end
    end

    private

    def assemble_identical_line_items
      # Find an existing line item which is like our new one
      existing_line_item = cart.line_items.find do |li|
        line_item.like?(li)
      end

      # If we found one, we assemble both line items into the old one, to avoid
      # duplicating the same sellables in the product list
      if existing_line_item
        existing_line_item.quantity += line_item.quantity
        @line_item = existing_line_item
      else
        false
      end
    end

    def sellable
      @sellable ||= sellable_class.find(line_item_params[:sellable_id])
    end

    def sellable_class
      @sellable_class ||= line_item_params[:sellable_type].camelize.constantize
    end

    def shipping_fee_service
      @shipping_fee_service ||= Stall::ShippingFeeCalculatorService.new(cart)
    end

    def line_item_params
      @line_item_params ||= params.require(:line_item).permit(
        :sellable_type, :sellable_id, :quantity
      )
    end
  end
end
