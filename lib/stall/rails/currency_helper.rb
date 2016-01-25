# Overrides the `#number_to_currency` rails helper to use the Money currency
# symbol as the unit when a Money object is passed and no unit is set.
#
# This allows to localize currency formats without messing around with Money
# custom format which is not integrated with the I18n gem, and rely on rails
# default way of localizing the currency formats.
#
module Stall
  module CurrencyHelper
    extend ActiveSupport::Concern

    included do
      if method_defined?(:number_to_currency)
        alias_method :original_number_to_currency, :number_to_currency

        define_method(:number_to_currency) do |price, options = {}|
          if Money === price && !options.key?(:unit)
            options[:unit] = price.symbol
          end

          original_number_to_currency(price, options)
        end
      end
    end
  end
end
