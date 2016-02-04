require 'rails_helper'

RSpec.describe Customer do
  it_behaves_like 'an addressable model', :customer

  it { should belong_to(:user).inverse_of(:customer) }
  it { should accept_nested_attributes_for(:user) }
end
