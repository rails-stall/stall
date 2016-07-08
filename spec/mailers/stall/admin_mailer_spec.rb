require 'rails_helper'

RSpec.describe Stall::AdminMailer do
  describe '#order_paid_email' do
    before(:all) do
      @cart = build_cart
    end

    it 'builds an email notification for the configured admins' do
      with_config :admin_email, 'admin@example.org' do
        mail = Stall::AdminMailer.order_paid_email(@cart)
        expect(mail.to).to eq(['admin@example.org'])
      end
    end

    it "is sent from the configured sender e-mail" do
      with_config :sender_email, 'sender@example.org' do
        mail = Stall::AdminMailer.order_paid_email(@cart)

        expect(mail.from).to eq(['sender@example.org'])
      end
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
