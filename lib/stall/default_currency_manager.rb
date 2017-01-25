module Stall
  module DefaultCurrencyManager
    extend ActiveSupport::Concern

    included do
      after_initialize :ensure_currency
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
