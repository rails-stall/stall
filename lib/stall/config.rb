module Stall
  class Config
    extend Stall::Utils::ConfigDSL

    # Default VAT rate
    param :vat_rate, BigDecimal.new('20.0')

    # Default prices precision for rounding
    param :prices_precision, 2

    # Engine's ApplicationController parent
    param :application_controller_ancestor, '::ApplicationController'

    # Default layout used for the checkout
    param :default_layout

    # Default currency for money objects
    param :default_currency, 'EUR'

    # Default checkout wizard used
    param :default_checkout_wizard, 'DefaultCheckoutWizard'

    # Default product weight if no weight is found
    param :default_product_weight, 0

    # Default step initialization hook
    param :_steps_initialization_callback

    def shipping
      @shipping ||= Stall::Shipping::Config.new
    end

    def steps_initialization(value = nil, &block)
      if (value ||= block)
        @_steps_initialization_callback = value
      else
        @_steps_initialization_callback
      end
    end
  end
end
