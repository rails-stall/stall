require 'rails_helper'

RSpec.describe Stall::AddToCartService do
  describe '#call' do
    it 'adds a sellable to the cart' do
      cart = create(:cart)
      sellable = create(:sellable)
      build_service(cart, sellable, 5).call

      line_item = cart.line_items.first

      expect(line_item.sellable).to eq(sellable)
      expect(line_item.quantity).to eq(5)
    end

    it 'merges line items from the same sellable' do
      sellable = create(:sellable)
      cart = create(:cart)

      build_service(cart, sellable, 2).call
      build_service(cart, sellable, 4).call

      expect(cart.line_items.length).to eq(1)
      expect(cart.line_items.first.quantity).to eq(6)
    end

    it 'returns true if the adding was successful' do
      sellable = create(:sellable)
      cart = create(:cart)
      service = build_service(cart, sellable, 2)

      expect(service.call).to eq(true)
    end

    it 'return false if the adding failed' do
      sellable = create(:sellable)
      cart = create(:cart)
      service = build_service(cart, sellable, 0)

      expect(service.call).to eq(false)
    end
  end

  def build_service(cart, sellable, quantity = 1)
    Stall::AddToCartService.new(cart, {
      sellable_type: sellable.class.name,
      sellable_id: sellable.id,
      quantity: quantity
    })
  end
end
