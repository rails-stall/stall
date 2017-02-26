require 'rails_helper'

RSpec.describe Shipment do
  it { should belong_to(:shipping_method) }
  it { should belong_to(:cart) }

  it { should monetize(:eot_price_cents) }
  it { should monetize(:price_cents) }

  describe '#currency' do
    it 'returns the cart currency if set' do
      cart = build(:cart, currency: 'GBP', shipment: build(:shipment))

      expect(cart.shipment.currency).to eq(Money::Currency.new('GBP'))
    end

    it 'returns the default currency if no cart is set' do
      shipment = build(:shipment)

      expect(shipment.currency).to eq(Money.default_currency)
    end
  end
end
