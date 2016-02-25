module Stall
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location)
      router.instance_eval do
        scope mount_location, module: :stall do
          resources :carts do
            resources :line_items
            resource :payment, only: [] do
              member do
                match 'process', action: 'process', via: [:get, :post]
              end
            end
          end

          resources :checkouts, only: [:show]

          scope '/checkout/:type/:cart_id', module: 'checkout', as: :checkout do
            resource :step, only: [:show, :update] do
              post '/', action: :update, as: :update
              get '/process', action: :update, as: :process
              get 'change/:step', action: :change, as: :change
            end
          end
        end
      end
    end
  end
end
