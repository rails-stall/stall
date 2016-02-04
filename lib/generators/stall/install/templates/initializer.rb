Stall.configure do |config|
  # Global default VAT rate, can be overrided by products
  #
  # config.vat_rate = BigDecimal.new('20.0')

  # Defines the default number of decimals precision used in prices
  #
  # config.prices_precision = 2

  # Default engine's controllers ancestor class
  #
  # config.application_controller_ancestor = '::ApplicationController'

  # Default currency used in the app for money objects.
  #
  # Note : If you need multi currency support in your app, you'll have to ensure
  # that you create your line items, carts and orders with the right currency
  # set.
  #
  # param :default_currency, 'EUR'

  # Defined the default checkout wizard used for checking carts out in the
  # shop process.
  #
  # Checkout wizards are used to customize the checkout steps.
  #
  # A default one is generated on stall's installation and can be found in your
  # app at : lib/default_checkout_wizard.rb
  #
  # config.default_checkout_wizard = 'DefaultCheckoutWizard'

  # Default line items weight when added to cart and no weight is found on
  # the sellable
  #
  # This allows for simply setting a weight here and not in each product
  # to calculate shipping fees depending on the total cart weight
  #
  # config.default_product_weight = 0

  # Allows configuring which countries are available for free shipping offers
  #
  # Accepts an array of country codes or a proc with an Address argument
  #
  # Defaults to nil, which means all countries are available
  #
  # config.shipping.free_shipping.available = nil

  # Allows hooking into checkout steps initialization in the steps controller
  # to inject dependencies to all or a specific step
  #
  # config.steps_initialization do |step|
  #   # Add the `current_user` in all steps
  #   step.inject(:current_user, current_user)
  #   # Only inject in the :some step :
  #   step.inject(:ip, request.remote_ip) if SomeCheckoutStep === step
  # end
end
