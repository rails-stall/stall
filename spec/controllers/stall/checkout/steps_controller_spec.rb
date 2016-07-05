require 'rails_helper'

class FakeCheckoutWizard < Stall::Checkout::Wizard
  steps :fake, :final
end

class FakeCheckoutStep < Stall::Checkout::Step
  def process
    false
  end
end

class FinalCheckoutStep < Stall::Checkout::Step
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

  def create_cart(options = {})
    allow(controller).to receive(:cart_class).and_return(FakeCart)

    controller.current_cart.reload.tap do |cart|
      cart.line_items << build(:line_item) unless options[:line_items]
      cart.assign_attributes(options)
      cart.save!
    end
  end
end
