require 'rails_helper'

RSpec.describe Stall::PaymentNotificationService do
  describe '#call' do
    it 'sets the cart payment as paid when the request is valid' do
      cart = create(:cart, payment: build(:payment))
      request = double(:request, params: { valid: true, success: true, cart_id: cart.id })
      service = Stall::PaymentNotificationService.new('fake-payment-gateway', request)

      allow(service).to receive(:send_payment_notification_emails!).and_return(true)

      expect(service.call).not_to be_nil
      expect(cart.payment.reload.paid_at).not_to be_nil
    end

    it 'sends the payment notification e-mails when valid' do
      mail = double(:mail, deliver: true)

      allow(Stall::CustomerMailer).to receive(:order_paid_email).and_return(mail)
      allow(Stall::AdminMailer).to receive(:order_paid_email).and_return(mail)

      expect(Stall::CustomerMailer).to receive(:order_paid_email)
      expect(Stall::AdminMailer).to receive(:order_paid_email)

      cart = create(:cart, payment: build(:payment))
      request = double(:request, params: { valid: true, success: true, cart_id: cart.id })

      service = Stall::PaymentNotificationService.new('fake-payment-gateway', request)

      service.call
    end

    it 'does nothing and return nil if the request has not been processed' do
      cart = create(:cart, payment: build(:payment))
      request = double(:request, params: { valid: true, success: false, cart_id: cart.id })

      service = Stall::PaymentNotificationService.new('fake-payment-gateway', request)

      allow(service).to receive(:send_payment_notification_emails!).and_return(true)

      expect(service.call).to be_nil
      expect(cart.payment.reload.paid_at).to be_nil
    end

    it 'raises an error when the request is invalid' do
      cart = create(:cart, payment: build(:payment))
      request = double(:request, params: { valid: false, cart_id: cart.id })

      service = Stall::PaymentNotificationService.new('fake-payment-gateway', request)

      allow(service).to receive(:send_payment_notification_emails!).and_return(true)

      expect { service.call }.to raise_error(Stall::PaymentNotificationService::UnknownNotificationError)
    end
  end

  describe '#rendering_options' do
    it 'delegates to the gateway' do
      service = Stall::PaymentNotificationService.new('fake-payment-gateway', double(:request))

      gateway_response = double(:gateway_response)
      expect(gateway_response).to receive(:rendering_options)
      allow(service).to receive(:gateway_response).and_return(gateway_response)

      service.rendering_options
    end
  end
end
