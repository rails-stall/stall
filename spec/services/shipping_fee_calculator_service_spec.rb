require 'rails_helper'

RSpec.describe Stall::ShippingFeeCalculatorService do
  describe '#call' do
    it 'updates the cart shipment price when a shipping method is set' do
      cart = create_cart

      Stall::ShippingFeeCalculatorService.new(cart).call

      expect(cart.shipment.price.to_f).to eq(5.7)
    end

    it 'does nothing and returns nil if no shipping method is set' do
      cart = create_cart
      cart.shipment.shipping_method = nil

      expect(Stall::ShippingFeeCalculatorService.new(cart).call).to eq(nil)
      expect(cart.shipment.price.to_f).to eq(0.0)
    end

    it 'does nothing and returns nil if no shipping calculator is found for the current shipping method' do
      cart = create_cart
      cart.shipment.shipping_method.identifier = 'undefined'

      expect(Stall::ShippingFeeCalculatorService.new(cart).call).to eq(nil)
      expect(cart.shipment.price.to_f).to eq(0.0)
    end

    it 'returns nil if no shipment is set' do
      cart = create_cart
      cart.shipment = nil

      expect(Stall::ShippingFeeCalculatorService.new(cart).call).to eq(nil)
    end


  end

  def create_cart
    build(:cart).tap do |cart|
      cart.shipping_address = build(:address, country: 'FR')
      cart.shipment = build(:shipment)
      cart.shipment.shipping_method = build(:shipping_method, identifier: 'fake-shipping-calculator')
      cart.save!
    end
  end
end
