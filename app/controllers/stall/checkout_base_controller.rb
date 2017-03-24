module Stall
  class CheckoutBaseController < Stall::ApplicationController
    include CheckoutHelper

    # Use specific checkout layout if needed or default to parent one
    #
    def set_stall_layout
      return false if request.xhr?
      return Stall.config.checkout_layout if Stall.config.checkout_layout

      super
    end
  end
end
