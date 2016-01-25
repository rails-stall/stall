module Stall
  module Checkout
    extend ActiveSupport::Autoload

    autoload :Wizard
    autoload :Step

    autoload :InformationsCheckoutStep
    autoload :ShippingMethodCheckoutStep
    autoload :PaymentMethodCheckoutStep
    autoload :PaymentCheckoutStep

    class WizardNotFoundError < StandardError; end
  end
end
