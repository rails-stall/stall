require 'rails_helper'

RSpec.describe PropertyValue do
  it { should belong_to(:property) }
  it { should have_many(:variant_property_values).dependent(:destroy).inverse_of(:property_value) }
  it { should have_many(:variants) }
  it { should validate_presence_of(:property) }
  it { should validate_presence_of(:value) }

  describe '#name' do
    it 'should return the #value' do
      property_value = build(:property_value, value: 'Size')
      expect(property_value.name).to eq('Size')
    end
  end

  describe '#name=' do
    it 'should set the #value' do
      property_value = build(:property_value)
      property_value.name = 'Size'
      expect(property_value.value).to eq('Size')
    end
  end
end
