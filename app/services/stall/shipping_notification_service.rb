module Stall
  class ShippingNotificationService < Stall::BaseService
    attr_reader :cart, :params

    def initialize(cart, params = {})
      @cart = cart
      @params = params
    end

    def call
      if shipment.update(shipment_params)
        send_customer_email
        update_shipment

        true
      else
        false
      end
    end

    private

    def shipment
      @shipment ||= cart.shipment || cart.build_shipment
    end

    def shipment_params
      params.require(:shipment).permit(:shipping_method_id, :tracking_code)
    end

    def send_customer_email
      Stall::CustomerMailer.order_shipped_email(cart).deliver
    end

    def update_shipment
      shipment.sent_at ||= Time.now
      shipment.notification_email_sent_at = Time.now
      shipment.shipped!
    end
  end
end
