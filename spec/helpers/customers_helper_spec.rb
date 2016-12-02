require 'rails_helper'


RSpec.describe Stall::CustomersHelper do
  describe '#stall_user_signed_in?' do
    it 'returns true when there is a signed in user' do
      allow(helper).to receive(:current_stall_user).and_return(build(:user))
      expect(helper.stall_user_signed_in?).to eq(true)
    end

    it 'returns false when there is no signed in user' do
      allow(helper).to receive(:current_stall_user).and_return(nil)
      expect(helper.stall_user_signed_in?).to eq(false)
    end
  end

  describe '#current_stall_user' do
    it 'returns the signed in user' do
      user = build(:user)

      allow(Stall.config).to receive(:default_user_helper_method).and_return(:current_user)
      allow(helper).to receive(:current_user).and_return(user)

      expect(helper.current_stall_user).to eq(user)
    end

    it 'returns nil when there is no signed in user' do
      allow(Stall.config).to receive(:default_user_helper_method).and_return(:current_user)
      allow(helper).to receive(:current_user).and_return(nil)

      expect(helper.current_stall_user).to eq(nil)
    end

    it 'returns nil when there is no configured user model' do
      allow(Stall.config).to receive(:default_user_helper_method).and_return(nil)
      expect(helper.current_stall_user).to eq(nil)
    end
  end

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
