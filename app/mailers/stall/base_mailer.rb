module Stall
  class BaseMailer < Stall.config.mailers_parent_class.constantize
    private

    def sender_email_for(cart)
      value_for(Stall.config.sender_email, cart)
    end

    def admin_email_for(cart)
      value_for(Stall.config.admin_email, cart)
    end

    def value_for(config, cart)
      Proc === config ? config.call(cart) : config
    end
  end
end
