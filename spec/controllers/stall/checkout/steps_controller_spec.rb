require 'rails_helper'

RSpec.describe Stall::Checkout::StepsController do
  describe '#show' do
    it 'injects needed dependencies to the step' do
      Stall.config.steps_initialization do |step|
        step.inject(:foo, 'bar')
      end

      cart = create(:cart)

      get :show, { type: 'default', cart_id: cart.token }

      expect(assigns(:step).foo).to eq('bar')
    end
  end

  describe '#update' do
    it 'injects needed dependencies to the step' do
      Stall.config.steps_initialization do |step|
        step.inject(:foo, 'bar')
      end

      cart = create(:cart)

      patch :update, { type: 'default', cart_id: cart.token, cart: { reference: 'foo'} }

      expect(assigns(:step).foo).to eq('bar')
    end
  end
end
