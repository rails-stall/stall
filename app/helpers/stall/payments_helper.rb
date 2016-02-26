module Stall
  module PaymentsHelper
    def payment_button_for(cart)
      request = Stall::Payments::Gateway.for(cart.payment.payment_method).request(cart)
      render partial: request.payment_form_partial_path, locals: { request: request }
    end
  end
end
