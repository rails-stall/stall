module Stall
  class CheckoutsController < Stall::ApplicationController
    include CheckoutHelper

    before_action :load_cart

    def show
      @cart.reset_state!
      Stall.config.service_for(:cart_update).new(@cart).refresh_associated_services!
      redirect_to step_path
    end

    private

    def load_cart
      @cart = current_cart
    end
  end
end
