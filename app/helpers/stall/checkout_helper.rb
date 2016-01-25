module Stall
  module CheckoutHelper
    def step_path(cart)
      checkout_step_path(cart.wizard.route_key, cart)
    end
  end
end
