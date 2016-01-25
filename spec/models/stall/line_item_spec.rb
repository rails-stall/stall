require 'rails_helper'

RSpec.describe Stall::LineItem do
  it { should belong_to(:sellable) }
  it { should belong_to(:product_list) }

  it { should monetize(:unit_price).allow_nil }
  it { should monetize(:unit_eot_price).allow_nil }
  it { should monetize(:price).allow_nil }
  it { should monetize(:eot_price).allow_nil }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:unit_price) }
  it { should validate_presence_of(:unit_eot_price) }
  it { should validate_presence_of(:vat_rate) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:quantity) }
  it { should validate_presence_of(:eot_price) }

  it { should validate_numericality_of(:unit_price) }
  it { should validate_numericality_of(:unit_eot_price) }
  it { should validate_numericality_of(:vat_rate) }
  it { should validate_numericality_of(:price) }
  it { should validate_numericality_of(:eot_price) }

  it { should validate_numericality_of(:quantity).is_greater_than(0) }

  it 'sets prices from unit prices and quantity before validation' do
    line_item = build(:line_item, unit_price: 10, quantity: 2)
    line_item.valid?
    expect(line_item.price.to_f).to eq(20.0)
  end

  describe '#like' do
    it 'returns true if the other line item has the same sellable' do
      sellable = create(:sellable)
      first_line_item = build(:line_item, sellable: sellable)
      second_line_item = build(:line_item, sellable: sellable)

      expect(first_line_item).to be_like(second_line_item)
    end

    it 'returns false if the other line item has another sellable' do
      first_line_item = build(:line_item, sellable: create(:sellable))
      second_line_item = build(:line_item, sellable: create(:sellable))

      expect(first_line_item).not_to be_like(second_line_item)
    end
  end

  describe '#currency' do
    it 'uses the currency of its parent product list if it exists' do
      product_list = build(:product_list, currency: 'GBP')
      line_item = build(:line_item, product_list: product_list)
      expect(line_item.unit_price.currency).to eq(product_list.currency)
    end

    it 'defaults to the global currency default if not attached to a product list' do
      line_item = build(:line_item)
      expect(line_item.unit_price.currency).to eq(Money.default_currency)
    end
  end
end
