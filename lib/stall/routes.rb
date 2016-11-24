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
          end

          get 'checkout/:cart_key' => 'checkouts#show', as: :checkout

          scope 'checkout', module: 'checkout', as: :checkout do
            scope '(:cart_key)' do
              resource :step, only: [:show, :update] do
                post '/', action: :update, as: :update
                get  '/process', action: :update, as: :process
                # Allow external URLs process steps, allowing some payment
                # gateways to return the user through a POST request
                post '/process', action: :foreign_update
                get 'change/:step', action: :change, as: :change
              end
            end
          end


          scope '/:gateway' do
            resource :payment, only: [] do
              member do
                match 'notify', action: 'notify', via: [:get, :post]
              end
            end
          end
        end
      end
    end
  end
end
