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
  end
end
