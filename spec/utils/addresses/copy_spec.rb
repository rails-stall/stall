require 'rails_helper'

RSpec.describe Stall::Addresses::Copy do
  describe '#copy' do
    it 'allows copying an address attributes to another' do
      source_address = build(:address)
      target_address = Address.new

      Stall::Addresses::Copy.new(source_address, target_address).copy

      target_address == source_address
    end
  end
end
