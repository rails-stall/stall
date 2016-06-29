module Stall
  class AdminMailer < Stall::BaseMailer
    def order_paid_email(cart)
      @cart = cart

      mail from: sender_email_for(cart),
           to: admin_email_for(cart),
           subject: I18n.t('stall.mailers.admin.order_paid_email.subject', ref: cart.reference)
    end
  end
end
