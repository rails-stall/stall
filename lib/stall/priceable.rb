module Stall
  module Priceable
    def vat
      price - eot_price
    end

    def vat_coefficient
      (1 + (vat_rate / 100.0))
    end
  end
end
