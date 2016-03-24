Stall.configure do |config|
  # Store name used by the system when a human readable identifier for your
  # store is needed, e.g. for payment gateways
  #
  config.store_name = "My stall (Change me in config/initializers/stall.rb)"

  # Configure the admin e-mail to which order notifications will be sent
  #
  # Either set the `STALL_ADMIN_EMAIL` env var or use the below config
  #
  # config.admin_email = ENV['STALL_ADMIN_EMAIL']

  # Configure the e-mail address used to send e-mails to customers for
  # order notifications
  #
  # Either set the `STALL_SENDER_EMAIL` env var or use the below config
  #
  # config.sender_email = ENV['STALL_SENDER_EMAIL']

  # Global default VAT rate, can be overrided by products
  #
  # config.vat_rate = BigDecimal.new('20.0')

  # Defines the default number of decimals precision used in prices
  #
  # config.prices_precision = 2

  # Default engine's controllers ancestor class
  #
  # config.application_controller_ancestor = '::ApplicationController'

  # Set a layout to use in the checkouts controllers
  #
  # The default is set to nil, which will make the controllers inherit from the
  # layout of the controller set in `config.application_controller_ancestor`
  #
  # config.default_layout = nil

  # Defines the parent mailer for the Stall customer and admin mailers
  #
  # If commented out, ActionMailer::Base will be used
  #
  config.mailers_parent_class = 'ApplicationMailer'

  # Default currency used in the app for money objects.
  #
  # Note : If you need multi currency support in your app, you'll have to ensure
  # that you create your line items, carts and orders with the right currency
  # set.
  #
  # param :default_currency, 'EUR'

  # Default app domain use for building URLs in payment gateway forms and in
  # e-mails.
  #
  # Add the `APP_DOMAIN` environment variable, or modify the parameter below.
  #
  # Ex : 'localhost:3000', 'www.example.com'
  #
  # config.default_app_domain = ENV['APP_DOMAIN']

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

  # Register custom shipping methods and calculators
  #
  # If no existing shipping method / calculator cover your needs, you can
  # create one by subclassing Stall::Shipping::Calculator
  #
  # Read more at : https://github.com/rails-stall/stall/wiki/Shipping-methods
  #
  # config.shipping.register_calculator :my_calculator, 'MyCalculator'

  # Register custom payment methods and gateways
  #
  # If no existing payment method / gateway cover your needs, you can
  # create one by subclassing Stall::Payments::Gateway
  #
  # Read more at : https://github.com/rails-stall/stall/wiki/Payment-methods
  #
  # config.payment.register_gateway :my_gateway, 'MyGateway'

  # Allows hooking into checkout steps initialization in the steps controller
  # to inject dependencies to all or a specific step
  #
  # config.steps_initialization do |step|
  #   # Add the `current_user` in all steps
  #   step.inject(:current_user, current_user)
  #   # Only inject in the :some step :
  #   step.inject(:ip, request.remote_ip) if SomeCheckoutStep === step
  # end

  # Configure app services to override default Stall services and add
  # functionalities to existing ones
  #
  # config.services = {
  #   payment_notification: 'PaymentNotificationService'
  # }
end
