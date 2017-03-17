module Stall
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location)
      router.instance_eval do
        devise_for :users, Stall.config.devise_for_user_config

        devise_scope :user do
          get '/users/omniauth/:provider/redirect' => 'stall/omniauth_callbacks#redirect', as: :user_omniauth_redirect
        end

        scope mount_location, module: :stall do
          constraints CuratedProductListExistsConstraint.new do
            resources :curated_product_lists, path: '/'
          end

          constraints ProductCategoryExistsConstraint.new do
            resources :product_categories, path: '/'
          end

          constraints ProductExistsConstraint.new do
            resources :products, path: '/'
          end

          resources :manufacturers

          resources :carts do
            resources :line_items
            resource :credit, controller: 'cart_credits', only: [:update, :destroy]
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

    class CuratedProductListExistsConstraint
      def matches?(request)
        CuratedProductList.exists?(slug: request.params[:id])
      end
    end

    class ProductExistsConstraint
      def matches?(request)
        Product.exists?(slug: request.params[:id])
      end
    end

    class ProductCategoryExistsConstraint
      def matches?(request)
        ProductCategory.exists?(slug: request.params[:id])
      end
    end
  end
end
