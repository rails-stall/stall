module Stall
  module Priceable
    def vat
      price - eot_price
    end
  end
end
