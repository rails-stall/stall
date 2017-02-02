require 'has_secure_token'
require 'vertebra'
require 'money-rails'
require 'request_store'
require 'haml-rails'
require 'simple_form'
require 'country_select'
require 'cocoon'
require 'deep_merge/rails_compat'
require 'para'

require 'stall/rails/routing_mapper'
require 'stall/rails/currency_helper'
require 'stall/engine'

require 'para/stall'

module Stall
  extend ActiveSupport::Autoload

  autoload :Sellable
  autoload :Addressable
  autoload :Addresses
  autoload :Priceable
  autoload :Payable
  autoload :Shippable
  autoload :Adjustable
  autoload :DefaultCurrencyManager
  autoload :ReferenceManager
  autoload :TotalPricesManager

  autoload :Checkout
  autoload :Shipping
  autoload :Payments

  autoload :Routes
  autoload :CartHelper
  autoload :ArchivedPaidCartHelper
  autoload :Config
  autoload :Utils

  def self.table_name_prefix
    'stall_'
  end

  def self.config
    @config ||= Stall::Config.new
  end

  def self.configure
    yield config
  end
end

