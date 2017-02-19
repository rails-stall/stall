require 'rails_helper'

RSpec.describe Stall::CartPaymentValidationService do
  describe '#call' do
    it 'sets the cart payment as paid when the request is valid' do
      stub_mailer_methods!

      cart = create(:cart, payment: build(:payment))
      service = Stall::CartPaymentValidationService.new(cart)

      expect(service.call).not_to be_nil
      expect(cart.paid?).to eq(true)
    end

    it 'sends the payment notification e-mails when valid' do
      stub_mailer_methods!

      expect(Stall::CustomerMailer).to receive(:order_paid_email)
      expect(Stall::AdminMailer).to receive(:order_paid_email)

      cart = create(:cart, payment: build(:payment))

      service = Stall::CartPaymentValidationService.new(cart)

      service.call
    end
  end

  def stub_mailer_methods!
    mail = double(:mail, deliver: true)

    allow(Stall::CustomerMailer).to receive(:order_paid_email).and_return(mail)
    allow(Stall::AdminMailer).to receive(:order_paid_email).and_return(mail)
  end
end
