module Stall
  class Config
    extend Stall::Utils::ConfigDSL

    # Default VAT rate
    param :vat_rate, BigDecimal.new('20.0')

    # Default prices precision for rounding
    param :prices_precision, 2

    # Engine's ApplicationController parent
    param :application_controller_ancestor, '::ApplicationController'

    # Default currency for money objects
    param :default_currency, 'EUR'

    # Default checkout wizard used
    param :default_checkout_wizard, 'DefaultCheckoutWizard'

    # Default product weight if no weight is found
    param :default_product_weight, 0

    def shipping
      @shipping ||= Stall::Shipping::Config.new
    end
  end
end
