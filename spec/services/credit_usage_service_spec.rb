require 'rails_helper'

RSpec.describe Stall::CreditUsageService do
  describe '#call' do
    it 'adds an adjustment of the requested amount when enough credit' do
      credit_note = create(:credit_note, amount: 50)
      customer = credit_note.customer
      cart = create_cart(customer, price: 150)

      Stall::CreditUsageService.new(cart, amount: 50).call

      adjustment = cart.adjustments.find { |adjustment| CreditNoteAdjustment === adjustment }

      expect(adjustment.price.to_d).to eq(-50)
      expect(cart.total_price.to_d).to eq(100)
    end

    it 'adds multiple adjustments if the needed customer credit spans accross multiple notes' do
      customer = create(:customer)
      2.times { create(:credit_note, customer: customer, amount: 50) }
      cart = create_cart(customer, price: 150)

      Stall::CreditUsageService.new(cart, amount: 75).call

      adjustments = cart.adjustments.select { |adjustment| CreditNoteAdjustment === adjustment }

      expect(adjustments.length).to eq(2)
      expect(adjustments.first.price.to_d).to eq(-50)
      expect(adjustments.last.price.to_d).to eq(-25)
    end

    it 'adds the whole cart price if no amount given and enough credit' do
      credit_note = create(:credit_note, amount: 100)
      customer = credit_note.customer
      cart = create_cart(customer, price: 50)

      Stall::CreditUsageService.new(cart).call

      adjustment = cart.adjustments.find { |adjustment| CreditNoteAdjustment === adjustment }

      expect(adjustment.price.to_d).to eq(-50)
      expect(cart.total_price.to_d).to eq(0)
    end

    it 'adds the whole customer credit if no amount given and the credit is smaller than the cart price' do
      credit_note = create(:credit_note, amount: 50)
      customer = credit_note.customer
      cart = create_cart(customer, price: 100)

      Stall::CreditUsageService.new(cart).call

      adjustment = cart.adjustments.find { |adjustment| CreditNoteAdjustment === adjustment }

      expect(adjustment.price.to_d).to eq(-50)
      expect(cart.total_price.to_d).to eq(50)
    end

    it 'returns false if the customer has not enough credit' do
      customer = create(:customer)
      cart = create_cart(customer, price: 150)

      result = Stall::CreditUsageService.new(cart, amount: 50).call

      expect(result).to eq(false)
      expect(cart.total_price.to_d).to eq(150)
    end

    it 'removes all previous credit note adjustments' do
      credit_note = create(:credit_note, amount: 50)
      customer = credit_note.customer
      cart = create_cart(customer, price: 100)
      previous_adjustment = build(:credit_note_adjustment)
      cart.adjustments << previous_adjustment

      Stall::CreditUsageService.new(cart).call

      expect(cart.adjustments).not_to include(previous_adjustment)
    end
  end

  def create_customer(credit: nil)
    credit_note = create(:credit_note, amount: credit)
    credit_note.customer
  end

  def create_cart(customer, price: nil)
    sellable = build(:sellable)
    line_items = [build(:line_item, sellable: sellable, unit_price: price)]
    create(:cart, customer: customer, line_items: line_items)
  end
end
