require 'rails_helper'

RSpec.describe Variant do
  it_should_behave_like 'a sellable model', :variant

  it { should belong_to(:product) }

  it { should have_many(:variant_property_values).dependent(:destroy).inverse_of(:variant) }
  it { should accept_nested_attributes_for(:variant_property_values).allow_destroy(true) }

  it { should have_many(:property_values) }
  it { should have_many(:properties) }

  it { should monetize(:price_cents) }

  it { should delegate_method(:image).to(:product) }
  it { should delegate_method(:image?).to(:product) }
  it { should delegate_method(:vat_rate).to(:product) }

  describe 'before validation' do
    it 'refreshes its name' do
      variant = build(:variant, name: nil)
      variant.validate

      expect(variant.name).not_to be_nil
    end
  end

  describe '.published' do
    it 'returns only published variants' do
      published_variant = create(:variant, published: true)
      unpublished_variant = create(:variant, published: false)

      published_variant_ids = Variant.published.pluck(:id)
      expect(published_variant_ids).to include(published_variant.id)
      expect(published_variant_ids).not_to include(unpublished_variant.id)
    end
  end

  describe '#refresh_name' do
    it 'sets its name to the products name and its properties values' do
      size_property_value = build(:property_value, name: 'L')
      size_property = build(:property, name: 'Size', property_values: [size_property_value])

      color_property_value = build(:property_value, name: 'Black')
      color_property = build(:property, name: 'Color', property_values: [color_property_value])

      variant = create(:variant,
        name: '',
        product: build(:product, name: 'Test product'),
        property_values: [size_property_value, color_property_value]
      )

      expect(variant.name).to eq('Test product / L - Black')
    end
  end
end
