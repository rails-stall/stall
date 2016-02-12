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

  describe '#build_billing_address' do
    it 'builds an address as the billing address ownership' do
      addressable = build(factory)
      addressable.build_billing_address(first_name: 'Jeannot')

      expect(addressable.billing_address.first_name).to eq('Jeannot')
    end

    it 'unmarks previous billing address as billing' do
      addressable = build(factory)
      ownership = addressable.address_ownerships.build(billing: true)
      addressable.build_billing_address

      expect(ownership.billing).to eq(false)
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

    it 'returns the first address from an address ownership marked as billing' do
      addressable = build(factory)
      ownership = addressable.address_ownerships.build(billing: true)
      address = ownership.build_address

      expect(addressable.billing_address).to eq(address)
    end

    it 'returns nil if no address of that type is found' do
      addressable = build(factory)

      expect(addressable.billing_address).to eq(nil)
    end
  end

  describe '#billing_address_attributes=' do
    it 'allows assigning attributes to the billing address' do
      addressable = build(factory)
      addressable.billing_address_attributes = { first_name: 'Jeannot' }

      expect(addressable.billing_address.first_name).to eq('Jeannot')
    end
  end
end
