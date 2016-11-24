module Stall
  class Config
    extend Stall::Utils::ConfigDSL
    # Store name used in e-mails and other interfaces duisplaying such an
    # information
    param :store_name

    # Admin e-mail address to which order notifications will be sent
    param :admin_email, -> { ENV['STALL_ADMIN_EMAIL'] || 'admin.change_me_in.stall.rb@example.com' }

    # E-mail address used to send e-mails to customers
    param :sender_email, -> { ENV['STALL_SENDER_EMAIL'] || 'shop.change_me_in.stall.rb@example.com' }

    # Email regex validation. Taken from Devise
    param :email_regexp, -> { (defined?(Devise) && Devise.email_regexp) || /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/ }

    # Default VAT rate
    param :vat_rate, BigDecimal.new('20.0')

    # Default prices precision for rounding
    param :prices_precision, 2

    # Engine's ApplicationController parent
    param :application_controller_ancestor, '::ApplicationController'

    param :mailers_parent_class, 'ActionMailer::Base'

    # Default layout used for the checkout
    param :default_layout

    # Default currency for money objects
    param :default_currency, 'EUR'

    # Default app domain for building routes
    param :default_app_domain

    # Default checkout wizard used
    param :default_checkout_wizard, 'DefaultCheckoutWizard'

    # Default product weight if no weight is found
    param :default_product_weight, 0

    # Default step initialization hook
    param :_steps_initialization_callback

    param :services, {}

    # Duration after which an empty cart is cleaned out by the rake task
    param :empty_carts_expires_after, 1.day

    # Duration after which an aborted cart is cleaned out by the rake task
    param :aborted_carts_expires_after, 14.days

    param :default_user_model_name, 'User'
    param :default_user_helper_method, :current_user

    # Configure the terms of service page path
    param :terms_path, 'about:blank'

    def shipping
      @shipping ||= Stall::Shipping::Config.new
    end

    def payment
      @payment ||= Stall::Payments::Config.new
    end

    def steps_initialization(value = nil, &block)
      if (value ||= block)
        @_steps_initialization_callback = value
      else
        @_steps_initialization_callback
      end
    end

    def default_app_domain
      @default_app_domain || ENV['APP_DOMAIN']
    end

    # Fetch user config and add top-namespace lookup to avoid collision
    # with Stall module services
    #
    # Default allows looking up Stall namespace automatically, when no
    # config has been given
    def service_for(identifier)
      class_name = if (service_name = services[identifier])
        "::#{ services[identifier].gsub(/^::/, '') }"
      else
        "Stall::#{ identifier.to_s.camelize }Service"
      end

      class_name.constantize
    end

    def services=(value)
      self.services.merge!(value)
    end

    def default_user_model
      default_user_model_name.try(:constantize)
    end
  end
end
