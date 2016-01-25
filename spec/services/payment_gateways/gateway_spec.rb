require 'rails_helper'

RSpec.describe Stall::Payments::Gateway do
  describe '.register' do
    it 'allows registering a gateway to the global gateways hash' do
      Stall::Payments::Gateway.register('fake')
      expect(Stall::Payments.gateways['fake']).to eq(Stall::Payments::Gateway)
    end
  end

  describe '#transaction_id' do
    it 'returns a new transaction id if none was set before' do
      cart = create(:cart, payment: build(:payment, transaction_id: nil))
      gateway = Stall::Payments::Gateway.new(cart)
      expect(gateway.transaction_id).to eq(cart.payment.transaction_id)
    end

    it 'returns the current payment transaction id if it exist' do
      cart = create(:cart, payment: build(:payment, transaction_id: 'test-1'))
      gateway = Stall::Payments::Gateway.new(cart)
      expect(gateway.transaction_id).to eq('test-1')
    end
  end

  describe '.cart_id_from' do
    it 'raises if not overriden' do
      expect {
        Stall::Payments::Gateway.cart_id_from(double(:request))
      }.to raise_error(NoMethodError)
    end
  end

  describe '.cart_id_from_transaction_id' do
    it 'returns a cart id from a transaction_id' do
      transaction_id = 'XXX-XXX-00001-XXX'
      cart_id = Stall::Payments::Gateway.cart_id_from_transaction_id(transaction_id)
      expect(cart_id).to eq(1)
    end

    it 'returns nil if transaction_id is nil' do
      cart_id = Stall::Payments::Gateway.cart_id_from_transaction_id(nil)
      expect(cart_id).to be_nil
    end
  end

  describe '#process_payment_for' do
    it 'raises if not overriden' do
      gateway = Stall::Payments::Gateway.new(double(:cart))

      expect {
        gateway.process_payment_for(double(:request))
      }.to raise_error(NoMethodError)
    end
  end

  describe '#rendering_options' do
    it 'returns a hash to pass to a controller #render call' do
      gateway = Stall::Payments::Gateway.new(double(:cart))
      expect(gateway.rendering_options[:text]).to eq(nil)
    end
  end
end
