module Stall
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    # This method is called with the options passed to the `mount_stall` routes
    # helper.
    #
    # You can pass it one of the following options to disable parts of the
    # routing :
    #
    #   - { users: false }  =>  Disables built in devise user authentication
    #   - { products: false } => Disables all products related routing
    #   - { checkout: false } => Disables all checkout and cart related routing
    #
    def draw(mount_location, options = {})
      routes = self

      users = options.fetch(:users, true)
      products = options.fetch(:products, true)
      checkout = options.fetch(:checkout, true)

      router.instance_eval do
        if users
          devise_for :users, Stall.config.devise_for_user_config

          devise_scope :user do
            get '/users/omniauth/:provider/redirect' => 'stall/omniauth_callbacks#redirect', as: :user_omniauth_redirect
          end
        end

        scope mount_location do
          if products
            resources :products, only: [:index], as: :products, controller: routes.controller_for(:products)

            constraints ProductExistsConstraint.new do
              resources :products, path: '/', only: [:show], controller: routes.controller_for(:products)
            end

            constraints ProductCategoryExistsConstraint.new do
              resources :product_categories, path: '/', only: [:show], controller: routes.controller_for(:product_categories) do
                 resources :products, only: [:show], path: '/', controller: routes.controller_for(:products)
              end
            end

            constraints CuratedProductListExistsConstraint.new do
              resources :curated_product_lists, path: '/', only: [:show], controller: routes.controller_for(:curated_product_lists) do
                resources :products, only: [:show], path: '/', controller: routes.controller_for(:products)
              end
            end

            constraints ManufacturerExistsConstraint.new do
              resources :manufacturers, path: '/', only: [:show], controller: routes.controller_for(:manufacturers) do
                resources :products, only: [:show], path: '/', controller: routes.controller_for(:products)
              end
            end
          end

          if checkout
            resources :carts, controller: routes.controller_for(:carts) do
              resources :line_items, only: [:create], controller: routes.controller_for(:cart_line_items)
              resource :credit, only: [:update, :destroy], controller: routes.controller_for(:cart_credits)
            end

            resources :wish_lists, only: [:show], controller: routes.controller_for(:wish_lists) do
              resources :line_items, only: [:create, :destroy], controller: routes.controller_for(:wish_list_line_items)
            end

            get 'checkout/:cart_key' => "#{routes.controller_for(:checkouts)}#show", as: :checkout

            scope 'checkout', as: :checkout do
              scope '(:cart_key)' do
                resource :step, only: [:show, :update], controller: routes.controller_for(:'checkout/steps') do
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
              resource :payment, only: [], controller: routes.controller_for(:payments) do
                member do
                  match 'notify', action: 'notify', via: [:get, :post]
                end
              end
            end
          end
        end
      end
    end

    def controller_for(key)
      Stall.config.controllers[key] || "stall/#{key}"
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

    class CuratedProductListExistsConstraint
      def matches?(request)
        id = request.params[:curated_product_list_id] || request.params[:id]
        CuratedProductList.exists?(slug: id)
      end
    end

    class ManufacturerExistsConstraint
      def matches?(request)
        id = request.params[:manufacturer_id] || request.params[:id]
        Manufacturer.exists?(slug: id)
      end
    end
  end
end
