module Stall
  class Engine < ::Rails::Engine
    initializer 'include sellable mixin into models' do
      ActiveSupport.on_load(:active_record) do
        include Stall::Sellable::Mixin
      end
    end
  end
end
