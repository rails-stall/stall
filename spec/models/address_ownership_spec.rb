require 'rails_helper'

RSpec.describe AddressOwnership do
  describe '#mark_as_shipping' do
    it 'removes the old addressable shipping ownership and sets self as the new one' do
      addressable = build(:customer)
      billing_ownership = addressable.address_ownerships.build(billing: true)
      shipping_ownership = addressable.address_ownerships.build(shipping: true)

      billing_ownership.mark_as_shipping

      expect(shipping_ownership.shipping).to eq(false)
      expect(billing_ownership.billing).to eq(true)
      expect(billing_ownership.shipping).to eq(true)
    end
  end
end
