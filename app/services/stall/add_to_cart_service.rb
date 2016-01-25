module Stall
  class AddToCartService < Stall::BaseService
    attr_reader :cart, :params

    def initialize(cart, params)
      @cart = cart
      @params = params
    end

    def call
      return false unless line_item.valid?

      unless assemble_identical_line_items
        cart.line_items << line_item
      end

      cart.save
    end

    def line_item
      @line_item ||= sellable.to_line_item.tap do |line_item|
        line_item.quantity = params[:quantity]
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
      @sellable ||= sellable_class.find(params[:sellable_id])
    end

    def sellable_class
      @sellable_class ||= params[:sellable_type].camelize.constantize
    end
  end
end
