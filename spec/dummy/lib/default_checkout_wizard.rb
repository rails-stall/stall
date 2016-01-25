class DefaultCheckoutWizard < Stall::Checkout::Wizard
  steps :informations, :shipping_method, :payment_method, :payment
end
