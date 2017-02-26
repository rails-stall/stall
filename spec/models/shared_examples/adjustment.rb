RSpec.shared_examples 'an adjustment' do |factory|
  it { should monetize(:price).allow_nil }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_presence_of(:cart) }

  describe 'before_validation' do
    it "fills the eot_price and vat_rate if they're empty" do
      adjustment = build(:adjustment, price: 12, eot_price: nil, vat_rate: nil)
      adjustment.save
      adjustment.reload

      expect(adjustment.send(:read_attribute, :eot_price_cents)).not_to be_nil
      expect(adjustment.send(:read_attribute, :vat_rate)).not_to be_nil
    end
  end

  describe '#eot_price' do
    it 'returns the eot_price attribute if it is filled' do
      adjustment = build(:adjustment, eot_price: 10)

      expect(adjustment.eot_price.to_i).to eq(10)
    end

    it 'returns the price attribute without the VAT if the attribute is empty' do
      adjustment = build(:adjustment, price: 10, eot_price: nil)

      expect(adjustment.eot_price).not_to eq(nil)
    end
  end

  describe '#vat_rate' do
    it 'returns the stall default vat rate if empty' do
      adjustment = build(:adjustment, vat_rate: nil)

      expect(adjustment.vat_rate).to eq(Stall.config.vat_rate)
    end
  end

  describe '#vat' do
    it 'returns the difference between the price and eot_price' do
      adjustment = build(:adjustment, eot_price: 10, price: 12)

      expect(adjustment.vat.to_i).to eq(2)
    end
  end
end
