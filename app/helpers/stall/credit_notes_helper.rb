module Stall
  module CreditNotesHelper
    def available_customer_credit_for?(cart)
      cart.customer.try(:credit?) || credit_used_for?(cart)
    end

    def maximum_credit_usage_for(cart)
      credit_usage_service_for(cart).amount.to_d
    end

    def current_customer_credit_for(cart)
      credit_usage_service_for(cart).credit
    end

    def credit_used_for?(cart)
      credit_usage_service_for(cart).credit_used?
    end

    private

    def credit_usage_service_for(cart)
      Stall.config.service_for(:credit_usage).new(cart)
    end
  end
end
