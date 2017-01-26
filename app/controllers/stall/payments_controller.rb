module Stall
  class PaymentsController < Stall::ApplicationController
    skip_before_action :verify_authenticity_token, only: [:notify]

    # Avoid user-requested payment notifications to remove the cart from cookies
    # as soon as it is paid
    skip_after_action  :store_cart_to_cookies

    def notify
      service = Stall.config.service_for(:payment_notification).new(params[:gateway], request)
      service.call

      # TODO : This is not the cleanest solution but an API change here would
      #        imply to rewrite most of the existing gateways.
      #
      #        This should be done as soon as we can to avoid keeping this
      #        dirty fix for too long
      #
      if (redirect_location = service.rendering_options[:redirect_location])
        redirect_to redirect_location
      else
        render service.rendering_options
      end
    end
  end
end
