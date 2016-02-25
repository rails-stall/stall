module Stall
  module Payments
    class Config
      extend Stall::Utils::ConfigDSL

      # This mehtod allows for registering an in-app gateway that can be
      # auto loaded without having to explicitly require it
      #
      # Use a string representing the gateway name if the target class is
      # auto-loaded by Rails
      #
      def register_gateway(name, gateway)
        Stall::Payments.gateways[name] = gateway
      end

      def configure
        yield self
      end

      def configure_urls(&block)
        Stall::Payments::UrlsConfig.config_block = block
      end

      def urls_for(cart)
        Stall::Payments::UrlsConfig.new(cart).parse
      end

      def method_missing(name, *args)
        if (gateway = Stall::Payments::Gateway.for(name))
          yield gateway
        else
          super
        end
      end
    end
  end
end
