require 'rails_helper'


RSpec.describe Stall::CustomersHelper do
  describe '#with_errors_from_user' do
    it 'adds the user e-mail errors to the customer errors' do
      user = build(:user)
      user.errors.add(:email, 'Error message')
      customer = build(:customer, user: user)
      customer = helper.with_errors_from_user(customer)

      expect(customer.errors.messages[:email].first).to eq('Error message')
    end
  end
end
