module Para
  module Stall
    class Routes < Para::Plugins::Routes
      def draw
        plugin :stall do
          crud_component controller: '/para/stall/admin/carts'
        end
      end
    end
  end
end
