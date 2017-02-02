module Stall
  module DefaultCurrencyManager
    extend ActiveSupport::Concern

    included do
      after_initialize :ensure_currency

      scope :for_currency, ->(currency) {
        where(table_name => { currency: currency.to_s })
      }
    end

    def currency
      if (currency = read_attribute(:currency).presence)
        Money::Currency.new(currency)
      else
        self.currency = Stall.config.default_currency
      end
    end

    private

    def ensure_currency
      self.currency ||= Stall.config.default_currency
    end
  end
end
