require 'rails_helper'

RSpec.describe Stall::PaymentNotificationService do
  describe '#call' do
    it 'sets the cart payment as paid when the request is valid' do
      cart = create(:cart, payment: build(:payment))
      allow(FakePaymentGateway).to receive(:cart_id_from).and_return(cart.id)

      request = double(:request, params: { gateway: 'fake-payment-gateway', success: true })
      service = Stall::PaymentNotificationService.new(request)

      expect(service.call).not_to be_nil
      expect(cart.payment.reload.paid_at).not_to be_nil
    end

    it 'does nothing and return nil if the request is invalid' do
      cart = create(:cart, payment: build(:payment))
      allow(FakePaymentGateway).to receive(:cart_id_from).and_return(cart.id)

      request = double(:request, params: { gateway: 'fake-payment-gateway', success: false })
      service = Stall::PaymentNotificationService.new(request)

      expect(service.call).to be_nil
      expect(cart.payment.reload.paid_at).to be_nil
    end
  end

  describe '#rendering_options' do
    it 'delegates to the gateway' do
      service = Stall::PaymentNotificationService.new(double(:request))

      gateway = double(:gateway)
      expect(gateway).to receive(:rendering_options)
      allow(service).to receive(:gateway).and_return(gateway)

      service.rendering_options
    end
  end
end
