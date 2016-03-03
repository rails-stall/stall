module Stall
  class PaymentsController < Stall::ApplicationController
    skip_before_action :verify_authenticity_token, only: [:notify]

    def notify
      service = Stall::PaymentNotificationService.new(params[:gateway], request)
      service.call
      render service.rendering_options
    end
  end
end
