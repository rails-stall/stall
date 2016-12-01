module Stall
  class Engine < ::Rails::Engine
    initializer 'stall.set_money_gem_default_currency' do
      Money.default_currency = Stall.config.default_currency
    end

    initializer 'stall.add_routing_mapper_extension' do
      ActionDispatch::Routing::Mapper.send(:include, Stall::RoutingMapper)
    end

    initializer 'stall.override_actionview_number_helpers' do
      ActiveSupport.on_load(:action_view) do
        include Stall::CurrencyHelper
      end
    end

    initializer 'stall.include_cart_helper' do
      ActiveSupport.on_load(:action_controller) do
        include Stall::CartHelper
      end
    end

    initializer 'stall.ensure_shipping_method_for_all_calculators' do
      Stall::Shipping.calculators.each_key do |name|
        ShippingMethod.where(identifier: name).first_or_create do |method|
          method.name = name.to_s.humanize
        end
      end
    end

    initializer 'stall.ensure_payment_method_for_all_gateways' do
      Stall::Payments.gateways.each_key do |name|
        PaymentMethod.where(identifier: name).first_or_create do |method|
          method.name = name.to_s.humanize
        end
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
