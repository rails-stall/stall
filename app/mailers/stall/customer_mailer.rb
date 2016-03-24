module Stall
  class CustomerMailer < Stall.config.mailers_parent_class.constantize
    def order_paid_email(cart)
      @cart = cart

      mail to: cart.customer.email,
           subject: I18n.t('stall.mailers.customer.order_paid_email.subject', ref: cart.reference)
    end
  end
end
