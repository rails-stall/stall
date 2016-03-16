module Stall
  class CheckoutsController < Stall::ApplicationController
    include CheckoutHelper

    before_action :load_cart

    def show
      @cart.reset_state!
      redirect_to step_path
    end

    private

    def load_cart
      @cart = current_cart
    end
  end
end
