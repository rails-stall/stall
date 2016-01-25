module Stall
  class CheckoutsController < ApplicationController
    def show
      @cart = Stall::Cart.find_by_token(params[:id])
      @cart.reset_state!
      redirect_to checkout_step_path(@cart.wizard.route_key, @cart)
    end
  end
end
