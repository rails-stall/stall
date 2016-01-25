require 'has_secure_token'
require 'vertebra'
require 'money-rails'
require 'request_store'
require 'haml-rails'
require 'simple_form'
require 'country_select'

require 'stall/rails/routing_mapper'
require 'stall/rails/currency_helper'
require 'stall/engine'

module Stall
  extend ActiveSupport::Autoload

  autoload :Sellable
  autoload :Addressable

  autoload :Checkout
  autoload :Shipping

  autoload :Routes
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
