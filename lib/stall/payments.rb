module Stall
  module Payments
    extend ActiveSupport::Autoload

    autoload :Gateway

    # autoload :Config

    mattr_reader :gateways
    @@gateways = {}
  end
end

