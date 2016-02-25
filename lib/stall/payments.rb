module Stall
  module Payments
    extend ActiveSupport::Autoload

    autoload :Gateway
    autoload :Config
    autoload :UrlsConfig
    autoload :FakeGatewayPaymentNotification

    mattr_reader :gateways
    @@gateways = {}.with_indifferent_access

    mattr_reader :payment_urls
    @@payment_urls = {}.with_indifferent_access
  end
end

