module Stall
  class Engine < ::Rails::Engine
    initializer 'stall.set_money_gem_default_currency' do
      Money.default_currency = Stall.config.default_currency
    end

    initializer 'stall.set_money_gem_infinite_precision' do
      Money.infinite_precision = true
    end

    initializer 'stall.add_routing_mapper_extension' do
      ActionDispatch::Routing::Mapper.send(:include, Stall::RoutingMapper)
    end

    initializer 'stall.override_actionview_number_helpers' do
      ActiveSupport.on_load(:action_view) do
        include Stall::CurrencyHelper
      end
    end

    config.to_prepare do
      ::ApplicationController.send(:include, Stall::CartHelper)
      ::ApplicationController.send(:include, Stall::ArchivedPaidCartHelper)
    end

    initializer 'stall.ensure_shipping_method_for_all_calculators' do
      register_class_models_for(ShippingMethod, Stall::Shipping.calculators)
    end

    initializer 'stall.ensure_payment_method_for_all_gateways' do
      require 'stall/payments/manual_payment_gateway'

      register_class_models_for(PaymentMethod, Stall::Payments.gateways)
    end

    initializer 'stall.add_stall_plugin_to_para_config' do
      Para.config.plugins += [:stall]
    end

    # For each omniauth provider in the config, declare a devise Omniauth
    # provider
    #
    initializer 'stall.add_omniauth_providers_to_devise', before: 'devise.omniauth' do
      Stall.config.omniauth_providers.each do |provider|
        Devise.omniauth(provider.name, provider.app_id, provider.secret_key, provider.config)
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

    def register_class_models_for(model, classes)
      return unless model.table_exists?

      classes.each_key do |name|
        model.where(identifier: name).first_or_create do |method|
          method.name = name.to_s.humanize
        end
      end
    end
  end
end
