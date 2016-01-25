module Stall
  class PaymentsController < ApplicationController
    def process
      service = Stall::PaymentNotificationService.new(request)
      service.call
      render service.rendering_options
    end
  end
end
