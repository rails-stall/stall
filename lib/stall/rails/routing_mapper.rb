# Routing mapper override to allow mounting the engine as non-isolated, avoiding
# issues with routes in templates when switching from the app to the engine
#
module Stall
  module RoutingMapper
    def mount_stall(*args)
      Stall::Routes.new(self).draw(*args)
    end
  end
end

