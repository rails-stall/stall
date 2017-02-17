module Para
  module Stall
    class Routes < Para::Plugins::Routes
      def draw
        plugin :stall do
          crud_component controller: '/para/stall/admin/carts' do
            resource :shipping_note, only: [:new, :create]
          end
        end
      end
    end
  end
end
