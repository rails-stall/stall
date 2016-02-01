module Stall
  module Checkout
    class StepsController < Stall::ApplicationController
      include Stall::CheckoutHelper

      before_action :load_step

      def show
        @step.prepare
      end

      def update
        if @step.process
          @wizard.validate_current_step!
          redirect_to step_path(@cart)
        else
          @step.prepare
          flash[:error] ||= t("stall.checkout.#{ @wizard.current_step_name }.error")
          render 'show'
        end
      end

      private

      def load_step
        @cart = Stall::Cart.find_by_token(params[:cart_id])
        @wizard = @cart.wizard.new(@cart)

        @step = @wizard.initialize_current_step do |step|
          # Inject request dependent
          step.inject(:params, params)
          step.inject(:session, session)
          step.inject(:request, request)
          step.inject(:flash, flash)

          if Stall.config.steps_initialization
            instance_exec(step, &Stall.config.steps_initialization)
          end
        end
      end
    end
  end
end
