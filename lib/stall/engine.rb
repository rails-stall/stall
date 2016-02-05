module Stall
  class Engine < ::Rails::Engine
    initializer 'set money gem default currency' do
      Money.default_currency = Stall.config.default_currency
    end

    initializer 'override actionview number helpers' do
      ActiveSupport.on_load(:action_view) do
        include Stall::CurrencyHelper
      end
    end

    initializer 'include cart helper' do
      ActiveSupport.on_load(:action_controller) do
        include Stall::CartHelper
      end
    end

    # Development : Configure rails generators to only generate the target
    # files and not try to generate useless complementary files
    #
    config.generators do |generators|
      generators.skip_routes     true
      generators.helper          false
      generators.stylesheets     false
      generators.javascripts     false
      generators.test_framework  false
    end
  end
end
