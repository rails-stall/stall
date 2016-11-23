class DefaultCheckoutWizard < Stall::Checkout::Wizard
  steps :informations, :payment, :payment_return
end
