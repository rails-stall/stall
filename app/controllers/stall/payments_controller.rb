module Stall
  class PaymentsController < Stall::ApplicationController
    skip_before_action :verify_authenticity_token, only: [:notify]

    def notify
      service = Stall.config.service_for(:payment_notification).new(params[:gateway], request)
      service.call
      render service.rendering_options
    end
  end
end
