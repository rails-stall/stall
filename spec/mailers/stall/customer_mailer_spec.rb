require 'rails_helper'

RSpec.describe Stall::CustomerMailer do
  describe '#order_paid_email' do
    before(:all) do
      @cart = build_cart
    end

    it 'builds an email notification for the cart customer' do
      mail = Stall::CustomerMailer.order_paid_email(@cart)
      expect(mail.to).to eq(['test@example.org'])
    end

    it "is sent from the configured sender e-mail" do
      with_config :sender_email, 'sender@example.org' do
        mail = Stall::CustomerMailer.order_paid_email(@cart)

        expect(mail.from).to eq(['sender@example.org'])
      end
    end

    it "sends the e-mail in the customer's locale" do
      @cart.customer.locale = :en
      mail = Stall::CustomerMailer.order_paid_email(@cart)

      expect(mail.subject).to eq(
        I18n.t('stall.mailers.customer.order_paid_email.subject', ref: @cart.reference, locale: :en)
      )
    end
  end

  def build_cart
    customer = build(:customer, email: 'test@example.org')
    address = build(:address)
    line_items = [build(:line_item)]
    shipment = build(:shipment)
    payment = build(:payment)

    cart = create(:cart,
      customer: customer,
      line_items: line_items,
      billing_address: address,
      shipping_address: address,
      shipment: shipment,
      payment: payment
    )
  end
end
