module Para
  module Stall
    module Admin
      class CartsController < ::Para::Admin::CrudResourcesController
        def index
          # Default to only showing paid carts
          params[:q] ||= {}
          params[:q][:payment_paid_at_null] ||= 0

          super

          # Only show filled carts, forget empty ones that just wait to be
          # cleaned up by the rake task
          @resources = @resources.filled
        end

        private

        def shipment_params
          params.require(:shipment).permit(
            :carrier, :tracking_code, :point_of_sale_id
          )
        end
      end
    end
  end
end
