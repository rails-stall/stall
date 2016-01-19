module Stall
  class Routes
    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location, options = {}, &block)
      router.instance_eval do
        scope mount_location do
          namespace :stall do
            resources :carts do
              resources :line_items
            end
          end
        end
      end
    end
  end
end
