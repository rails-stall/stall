require 'rails_helper'

RSpec.describe Stall::CartCreditNoteCreationService do
  describe '#call' do
    it 'creates a credit note for the customer of the amount of the cart remainder' do
      with_config :convert_cart_remainder_to_credit_note, true do
        cart = create(:cart, customer: build(:customer))
        allow(cart).to receive(:original_total_price).and_return(money(-50))
        service = Stall::CartCreditNoteCreationService.new(cart)

        expect(service.call).to eq(true)
        expect(cart.adjustments.first).to be_a(CartCreditNoteAdjustment)
        expect(cart.adjustments.first.price).to eq(money(50))
      end
    end

    it 'returns false if there is no remainder in the cart' do
      with_config :convert_cart_remainder_to_credit_note, true do
        cart = create(:cart)
        allow(cart).to receive(:original_total_price).and_return(money(100))

        service = Stall::CartCreditNoteCreationService.new(cart)

        expect(service.call).to eq(false)
      end
    end
  end
end
