module Stall
  class CartPaymentValidationService < Stall::BaseService
    attr_reader :cart

    def initialize(cart)
      @cart = cart
    end

    def call
      cart.payment.pay!
      send_payment_notification_emails!
      create_credit_notes!
    end

    private

    def send_payment_notification_emails!
      Stall::CustomerMailer.order_paid_email(cart).deliver
      Stall::AdminMailer.order_paid_email(cart).deliver
    end

    def create_credit_notes!
      if cart.remainder?
        Stall.config.service_for(:cart_credit_note_creation).new(cart).call
      end
    end
  end
end
