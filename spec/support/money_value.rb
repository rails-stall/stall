module MoneyValue
  def money(amount, currency = Stall.config.default_currency)
    Money.new(amount * 100, Stall.config.default_currency)
  end
end
