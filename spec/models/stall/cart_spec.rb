require 'rails_helper'

RSpec.describe Stall::Cart do
  it_behaves_like 'a product list', :product_list
  it_behaves_like 'an addressable model', :cart

  it { should have_one(:shipment).dependent(:destroy) }
  it { should accept_nested_attributes_for(:shipment) }

  it { should have_one(:payment).dependent(:destroy) }
  it { should accept_nested_attributes_for(:payment) }

  describe '#total_weight' do
    it 'returns the total weight of the cart line items' do
      cart = build(:cart)
      cart.line_items << build(:line_item, weight: 100)
      cart.line_items << build(:line_item, weight: 200)

      expect(cart.total_weight).to eq(300)
    end
  end

  it 'sets its reference on creation' do
    cart = create(:cart, reference: nil)
    expect(cart.reference).not_to be_nil
  end
end
