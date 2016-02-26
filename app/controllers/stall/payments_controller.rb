module Stall
  class PaymentsController < Stall::ApplicationController
    def notify
      service = Stall::PaymentNotificationService.new(params[:gateway], request)
      service.call
      render service.rendering_options
    end
  end
end
