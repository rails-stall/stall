module Stall
  module Payments
    class UrlsConfig
      include Rails.application.routes.url_helpers

      class_attribute :config_block

      attr_reader   :cart

      attr_accessor :payment_notification_url,
                    :payment_success_return_url,
                    :payment_failure_return_url

      def initialize(cart)
        @cart = cart

        # Parse URLs
        instance_exec(self, &config_block)
      end

      private

      def config_block
        self.class.config_block || default_config
      end

      def default_config
        -> urls {
          urls.payment_notification_url   = notify_payment_url(gateway: gateway_identifier, host: Stall.config.default_app_domain)
          urls.payment_success_return_url = process_checkout_step_url(cart.wizard.route_key, cart, host: Stall.config.default_app_domain)
          urls.payment_failure_return_url = process_checkout_step_url(cart.wizard.route_key, cart, host: Stall.config.default_app_domain)
        }
      end

      def gateway_identifier
        @gateway_identifier ||= cart.payment.payment_method.identifier
      end
    end
  end
end
