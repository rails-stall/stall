require 'rails_helper'

RSpec.describe Stall::CheckoutsController do
  include CheckoutSpecHelper

  describe '#show' do
    it "resets cart checkout state and redirects to wizard's first step" do
      cart = create_cart(state: :final)

      get :show, cart_key: cart.identifier

      expect(cart.reload.state).to eq(:fake)
      expect(response).to redirect_to(checkout_step_path(cart_key: cart.identifier))
    end
  end
end
