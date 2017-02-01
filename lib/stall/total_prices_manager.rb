# The TotalPricesManager module allows hadling total prices and VAT totals and
# managing negative total prices, thus generating a remainder and allowing it
# to be converted to a credit note later.
#
module Stall
  module TotalPricesManager
    extend ActiveSupport::Concern

    [:price, :eot_price, :vat].each do |method_name|
      define_method(:"original_total_#{ method_name }") do            # def original_total_price
        ensure_money(items.map(&method_name).sum)                     #   ensure_money(items.map(&:price).sum)
      end                                                             # end

      define_method(:"total_#{ method_name }") do                     # def total_price
        original_total = send(:"original_total_#{ method_name }")     #   original_total = original_total_price
        [original_total, Money.new(0, currency)].max                  #   [original_total, 0].max
      end                                                             # end
    end

    # Returns the balance between the actual total price and the zero-floored
    # total price displayed to the users.
    #
    # This allows for calculating credit notes amount when an order is paid
    # with a negative remainder
    #
    def remainder
      total_price - original_total_price
    end

    def remainder?
      Stall.config.convert_cart_remainder_to_credit_note && remainder.to_d > 0
    end

    private

    def ensure_money(price)
      (Money === price) ? price : Money.new(price, currency)
    end
  end
end
