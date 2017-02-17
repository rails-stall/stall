module Stall
  class CustomerMailer < Stall::BaseMailer
    def order_paid_email(cart)
      I18n.with_locale(cart.customer.locale) do
        @cart = cart

        mail from: sender_email_for(cart),
             to: cart.customer.email,
             subject: I18n.t('stall.mailers.customer.order_paid_email.subject', ref: cart.reference)
      end
    end

    def order_shipped_email(cart)
      I18n.with_locale(cart.customer.locale) do
        @cart = cart

        calculator_class = Stall::Shipping::Calculator.for(cart.shipment.shipping_method)
        @calculator = calculator_class.new(cart, cart.shipment.shipping_method)

        @tracking_url = if @calculator.trackable?
          cart.shipment.tracking_code.presence && @calculator.tracking_url
        end

        subject = t('stall.mailers.customer.order_shipped_email.subject', ref: cart.reference)

        mail from: sender_email_for(cart),
             to: cart.customer.email,
             subject: subject
      end
    end
  end
end
