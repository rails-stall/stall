require 'rails_helper'

RSpec.describe Stall::ShippingMethod do
  it { should have_many(:shipments).dependent(:nullify) }
end
