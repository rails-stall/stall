module Stall
  module PricesHelper
    def displayed_price_for_variants variants
      if variants.length == 1
        number_to_currency(variants.first.price)
      else
        price = variants.map(&:price).min
        t('stall.products.prices.from', price: number_to_currency(price)) if price
      end
    end
  end
end
