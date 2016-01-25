module Stall
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location, options = {}, &block)
      router.instance_eval do
        scope mount_location do
          scope module: :stall do
            resources :carts do
              resources :line_items
            end

            resources :checkouts, only: [:show]

            scope '/checkout/:type/:cart_id', module: 'checkout', as: :checkout do
              resource :step, only: [:show, :update]
            end
          end
        end
      end
    end
  end
end
