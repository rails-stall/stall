require 'rails_helper'

RSpec.describe Stall::Customer do
  it_behaves_like 'an addressable model', :customer
end
