module Stall
  class Engine < ::Rails::Engine
    initializer 'include sellable mixin into models' do
      ActiveSupport.on_load(:active_record) do
        include Stall::Sellable::Mixin
      end
    end

    initializer 'set money gem default currency' do
      Money.default_currency = Stall.config.default_currency
    end

    initializer 'override actionview number helpers' do
      ActiveSupport.on_load(:action_view) do
        include Stall::CurrencyHelper
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
