module Stall
  class PaymentNotificationService < Stall::BaseService
    class UnknownNotificationError < StandardError; end

    attr_reader :gateway_identifier, :request

    def initialize(gateway_identifier, request)
      @gateway_identifier = gateway_identifier
      @request = request
    end

    def call
      if gateway_response.valid?
        send_payment_notification_emails! if gateway_response.notify
      else
        raise UnknownNotificationError,
              "The payment notification request does not seem to come from " +
              "the \"#{ gateway_identifier }\" gateway."
      end
    end

    def rendering_options
      gateway_response.rendering_options
    end

    private

    def gateway_class
      @gateway_class ||= Stall::Payments.gateways[gateway_identifier]
    end

    def gateway_response
      @gateway_response ||= gateway_class.response(request)
    end

    def send_payment_notification_emails!
      Stall::CustomerMailer.order_paid_email(gateway_response.cart).deliver
      Stall::AdminMailer.order_paid_email(gateway_response.cart).deliver
    end
  end
end
