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
      end
    end
  end
end
