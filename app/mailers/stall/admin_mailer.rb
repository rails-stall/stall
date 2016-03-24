module Stall
  class AdminMailer < Stall.config.mailers_parent_class.constantize
    def order_paid_email(cart)
      @cart = cart

      mail to: Stall.config.admin_email,
           subject: I18n.t('stall.mailers.admin.order_paid_email.subject', ref: cart.reference)
    end
  end
end
