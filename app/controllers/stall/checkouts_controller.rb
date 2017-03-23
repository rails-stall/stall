module Stall
  class CheckoutsController < Stall::CheckoutBaseController
    before_action :load_cart

    def show
      @cart.reset_state!
      refresh_cart!
      redirect_to step_path
    end

    private

    def load_cart
      @cart = current_cart
    end

    def refresh_cart!
      service = Stall.config.service_for(:cart_update).new(@cart)
      service.refresh_associated_services!
    end
  end
end
