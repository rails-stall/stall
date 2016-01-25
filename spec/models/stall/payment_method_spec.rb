require 'rails_helper'

RSpec.describe Stall::PaymentMethod do
  it { should have_many(:payments).dependent(:nullify) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:identifier) }
end
