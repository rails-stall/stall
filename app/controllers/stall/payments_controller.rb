module Stall
  class PaymentsController < Stall::ApplicationController
    def process
      service = Stall::PaymentNotificationService.new(params[:gateway], request)
      service.call
      render service.rendering_options
    end
  end
end
