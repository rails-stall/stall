require 'rails_helper'


RSpec.describe Stall::CheckoutHelper do
  describe '#available_shipping_methods_for' do
    it 'returns available shipping methods for a given cart, based on shipping calculators conditions' do
      cart = build(:cart)
      fake = build(:shipping_method, identifier: 'fake-shipping-calculator')

      allow(ShippingMethod).to receive(:ordered).and_return([fake])
      allow_any_instance_of(FakeShippingCalculator).to receive(:available?).and_return(true)

      expect(helper.available_shipping_methods_for(cart)).to eq([fake])
    end

    it 'does not return shipping methods unavailable to the given cart' do
      cart = build(:cart)
      fake = build(:shipping_method, identifier: 'fake-shipping-calculator')

      allow(ShippingMethod).to receive(:ordered).and_return([fake])
      allow_any_instance_of(FakeShippingCalculator).to receive(:available?).and_return(false)

      expect(helper.available_shipping_methods_for(cart)).to eq([])
    end

    it 'raises if no shipping calculator is found for an existing shipping method' do
      cart = build(:cart)
      fake = build(:shipping_method, identifier: 'foo')

      allow(ShippingMethod).to receive(:ordered).and_return([fake])

      expect { helper.available_shipping_methods_for(cart) }.to raise_error(Stall::Shipping::CalculatorNotFound)
    end
  end
end
