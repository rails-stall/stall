module Stall
  module Checkout
    class StepsController < Stall::ApplicationController
      include Stall::CheckoutHelper

      before_action :load_cart
      before_action :load_step
      before_action :ensure_cart_checkoutable

      def show
        @step.prepare
      end

      def update
        if @step.process
          @wizard.validate_current_step!
          redirect_to step_path
        else
          @step.prepare
          flash[:error] ||= t("stall.checkout.#{ @wizard.current_step_name }.error")
          render 'show'
        end
      end

      def change
        target_step = params[:step]

        if @wizard.step_complete?(target_step)
          @wizard.move_to_step!(target_step)
          redirect_to step_path
        else
          @step.prepare
          flash[:error] ||= t("stall.checkout.#{ target_step }.error")
          render 'show'
        end
      end

      private

      def load_cart
        @cart = current_cart
      end

      def find_cart(identifier, ensure_active_cart = true)
        super(identifier, false)
      end

      def ensure_cart_checkoutable
        unless @cart.active? || @step.allow_inactive_carts?
          remove_cart_from_cookies(@cart.identifier)
          @cart = @cart.class.new
        end

        unless @cart.checkoutable?
          flash[:error] = t('stall.checkout.shared.not_checkoutable')
          redirect_to request.referrer || root_path
        end
      end

      def load_step
        @wizard = @cart.wizard.new(@cart)

        @step = @wizard.initialize_current_step do |step|
          # Inject request dependent data
          step.inject(:params, params)
          step.inject(:session, session)
          step.inject(:cookies, cookies)
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
