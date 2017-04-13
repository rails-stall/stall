module Stall
  class AvailableStocksService < Stall::BaseService
    def on_hand?(line_item)
      if Stall.config.manage_inventory
        line_item.variant.stock >= line_item.quantity
      else
        true
      end
    end
  end
end
