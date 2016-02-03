require 'rails_helper'

RSpec.describe Stall::Shipping::CountryWeightTableCalculator do
  describe '#availables?' do
    it 'returns true when the given country code is present' do
      calculator = FakeShippingCalculator.new(build(:cart), build(:shipping_method))
      calculator.cart.shipping_address = build(:address, country: 'FR')

      expect(calculator.available?).to eq(true)
    end

    it 'returns false when the given country does not exist in the table' do
      calculator = FakeShippingCalculator.new(build(:cart), build(:shipping_method))
      calculator.cart.shipping_address = build(:address, country: 'UY')

      expect(calculator.available?).to eq(false)
    end
  end

  describe '#price' do
    it 'returns the first price that matches the cart country and weight' do
      cart = build(:cart)
      cart.line_items << build(:line_item, weight: 0.5)
      cart.line_items << build(:line_item, weight: 1)
      cart.shipping_address = build(:address, country: 'GB')

      calculator = FakeShippingCalculator.new(cart, build(:shipping_method))

      expect(calculator.price).to eq(17.35)
    end

    it 'returns nil if no price was found for the cart country or weight' do
      cart = build(:cart)
      cart.line_items << build(:line_item, weight: 2)
      cart.line_items << build(:line_item, weight: 1)
      cart.shipping_address = build(:address, country: 'GB')

      calculator = FakeShippingCalculator.new(cart, build(:shipping_method))

      expect(calculator.price).to eq(nil)
    end
  end
end
