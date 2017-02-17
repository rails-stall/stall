module Para
  module Stall
    module Admin
      class ShippingNotesController < ::Para::Admin::ComponentController
        before_filter :load_cart
        authorize_resource :cart
        authorize_resource :shipment

        def new
          render layout: false
        end

        def create
          service = ::Stall.config.service_for(:shipping_notification).new(@cart, params)

          if service.call
            render 'sent', layout: false
          else
            flash_message(:error)
            render 'new', layout: false
          end
        end

        private

        def load_cart
          @cart = ProductList.find(params[:resource_id])
          @shipment = @cart.shipment || @cart.build_shipment
        end
      end
    end
  end
end
