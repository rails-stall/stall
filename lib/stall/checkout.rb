module Stall
  module Checkout
    extend ActiveSupport::Autoload

    autoload :Wizard
    autoload :Step
    autoload :StepForm

    autoload :InformationsCheckoutStep
    autoload :ShippingMethodCheckoutStep
    autoload :PaymentMethodCheckoutStep
    autoload :PaymentCheckoutStep
    autoload :PaymentReturnCheckoutStep

    class WizardNotFoundError < StandardError; end
  end
end
