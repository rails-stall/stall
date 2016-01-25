require 'rails_helper'

RSpec.describe Book do
  it_behaves_like 'a sellable model', :book
end
