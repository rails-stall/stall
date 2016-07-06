require 'rails_helper'

RSpec.describe Stall::Checkout::StepsController do
  include CheckoutSpecHelper

  describe '#show' do
    it 'injects needed dependencies to the step' do
      with_config :steps_initialization, ->(step) { step.inject(:foo, 'bar') } do
        cart = create_cart

        get :show, cart_key: cart.identifier

        expect(assigns(:step).foo).to eq('bar')
      end
    end
  end

  describe '#update' do
    it 'handles unsuccessful steps with an error message' do
      cart = create_cart

      patch :update, cart_key: cart.identifier, cart: { customer_attributes: { email: '' } }

      expect(flash[:error]).not_to be_nil
    end

    it 'injects needed dependencies to the step' do
      with_config :steps_initialization, ->(step) { step.inject(:foo, 'bar') } do
        cart = create_cart

        patch :update, cart_key: cart.identifier, cart: { state: 'fake' }

        expect(assigns(:step).foo).to eq('bar')
      end
    end
  end

  describe '#change' do
    it 'allows moving the checkout to a previous step' do
      cart = create_cart(state: :final)
      get :change, cart_key: cart.identifier, step: :fake

      expect(cart.reload.state).to eq(:fake)
    end

    it 'disallows moving the checkout to a step not already completed' do
      cart = create_cart(state: :fake)
      get :change, cart_key: cart.identifier, step: :final

      expect(cart.reload.state).to eq(:fake)
      expect(flash[:error]).not_to be_nil
    end
  end
end
