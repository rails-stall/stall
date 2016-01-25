RSpec.shared_examples 'an addressable model' do |factory|
  it { should have_many(:address_ownerships).dependent(:destroy) }
  it { should have_many(:addresses) }

  describe '#address_ownership_for' do
    it 'returns the address ownership for the given address type' do
      addressable = build(factory)
      address = build(:address)
      ownership = addressable.address_ownerships.build(address: address, billing: true)

      expect(addressable.address_ownership_for(:billing)).to eq(ownership)
    end

    it 'returns nil if no address of that type is found' do
      addressable = build(factory)

      expect(addressable.address_ownership_for(:billing)).to eq(nil)
    end
  end

  # Works equally for `#shipping_address=`
  describe '#billing_address=' do
    it 'assigns an address to the billing address ownership' do
      addressable = build(factory)
      address = build(:address)
      addressable.billing_address = address

      expect(addressable.billing_address).to eq(address)
    end
  end

  describe '#billing_address' do
    it 'returns the first address marked as billing' do
      addressable = build(factory)
      address = build(:address)
      addressable.shipping_address = build(:address)
      addressable.billing_address = address

      expect(addressable.billing_address).to eq(address)
    end

    it 'returns nil if no address of that type is found' do
      addressable = build(factory)

      expect(addressable.billing_address).to eq(nil)
    end
  end
end
