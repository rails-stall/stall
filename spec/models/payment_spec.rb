require 'rails_helper'

RSpec.describe Payment do
  it { should belong_to(:payment_method) }
  it { should belong_to(:cart) }

  it { should validate_presence_of(:payment_method) }
  it { should validate_presence_of(:cart) }
end
