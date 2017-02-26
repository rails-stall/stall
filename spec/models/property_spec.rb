require 'rails_helper'

RSpec.describe Property do
  it { should have_many(:property_values).dependent(:destroy).inverse_of(:property) }
  it { should accept_nested_attributes_for(:property_values).allow_destroy(true) }
  it { should have_many(:variant_property_values) }
  it { should have_many(:variants) }
  it { should validate_presence_of(:name) }
end
