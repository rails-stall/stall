require 'rails_helper'

RSpec.describe ShippingMethod do
  it { should have_many(:shipments).dependent(:nullify) }
end
