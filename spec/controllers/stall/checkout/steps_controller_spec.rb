require 'rails_helper'

class FakeCheckoutWizard < Stall::Checkout::Wizard
  steps :fake
end

class FakeCheckoutStep < Stall::Checkout::Step
  def process
    false
  end
end

class FakeCart < Stall::Cart
  def wizard
    FakeCheckoutWizard
  end
end

RSpec.describe Stall::Checkout::StepsController do
  describe '#show' do
    it 'injects needed dependencies to the step' do
      with_config :steps_initialization, ->(step) { step.inject(:foo, 'bar') } do
        cart = create_cart

        get :show, { type: 'default', cart_id: cart.token }

        expect(assigns(:step).foo).to eq('bar')
      end
    end
  end

  describe '#update' do
    it 'handles unsuccessful steps with an error message' do
      cart = create_cart
      patch :update, { type: 'default', cart_id: cart.token }
      expect(flash[:error]).not_to be_nil
    end

    it 'injects needed dependencies to the step' do
      with_config :steps_initialization, ->(step) { step.inject(:foo, 'bar') } do
        cart = create_cart

        patch :update, { type: 'default', cart_id: cart.token }

        expect(assigns(:step).foo).to eq('bar')
      end
    end
  end

  def create_cart
    create(:cart, type: 'FakeCart', state: 'fake')
  end
end
