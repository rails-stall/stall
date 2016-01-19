require 'has_secure_token'
require 'vertebra'

require 'stall/rails/routing_mapper'
require 'stall/engine'

module Stall
  extend ActiveSupport::Autoload

  autoload :Sellable
  autoload :Routes
  autoload :Config

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

