require 'rails_helper'

RSpec.describe ProductCategory do
  it { should have_many(:products).dependent(:nullify) }
  it { should validate_presence_of(:name) }

  describe '.ordered' do
    it 'returns categories ordered by position' do
      first_category = create(:product_category)
      second_category = create(:product_category)

      ordered_category_ids = ProductCategory.ordered.pluck(:id)

      expect(ordered_category_ids.first).to eq(first_category.id)
    end
  end
end
