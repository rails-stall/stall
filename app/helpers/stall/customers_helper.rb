module Stall
  module CustomersHelper
    def stall_user_signed_in?
      !!current_stall_user
    end

    def current_stall_user
      send(Stall.config.default_user_helper_method)
    end
  end
end
