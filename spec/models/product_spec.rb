require 'rails_helper'

RSpec.describe Product do
  it { should belong_to(:product_category) }
  it { should belong_to(:manufacturer) }

  it { should have_many(:variants).dependent(:destroy).inverse_of(:product) }
  it { should accept_nested_attributes_for(:variants).allow_destroy(true) }

  it { should have_many(:product_details).dependent(:destroy).inverse_of(:product) }
  it { should accept_nested_attributes_for(:product_details).allow_destroy(true) }

  it { should have_attached_file(:image) }

  it { should validate_presence_of(:name) }
  it { should validate_attachment_content_type(:image).allowing('image/jpg', 'image/png').rejecting('text/plain', 'application/pdf') }

  describe '.visible' do
    it 'returns visible products' do
      visible_product = create(:product, visible: true)
      invisible_product = create(:product, visible: false)

      visible_product_ids = Product.visible.pluck(:id)

      expect(visible_product_ids).to include(visible_product.id)
      expect(visible_product_ids).not_to include(invisible_product.id)
    end
  end

  describe '#vat_rate' do
    it 'returns the default stall VAT rate' do
      product = build(:product)
      expect(product.vat_rate).to eq(Stall.config.vat_rate)
    end
  end

  describe '#price' do
    it 'returns the smallest price from its variants' do
      first_variant = build(:variant, price: 10)
      second_variant = build(:variant, price: 20)

      product = build(:product, variants: [first_variant, second_variant])

      expect(product.price).to eq(first_variant.price)
    end
  end
end
