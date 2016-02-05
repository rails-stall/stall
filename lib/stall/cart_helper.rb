module Stall
  module CartHelper
    extend ActiveSupport::Concern

    included do
      helper_method :current_cart
    end

    def current_cart
      RequestStore.store[cart_key] ||= load_current_cart
    end

    private

    def current_cart_key
      :default
    end

    def load_current_cart(type = current_cart_key)
      if (cart_token = session[cart_key(type)])
        if (current_cart = Cart.find_by_token(cart_token))
          return current_cart
        end
      end

      # If no token was stored or the token does not exist anymore, create a
      # new cart and store the new token
      #
      Cart.create!.tap do |cart|
        session[cart_key(type)] = cart.token
      end
    end

    def cart_key(identifier = current_cart_key)
      ['stall', 'cart', identifier.to_s].join('.')
    end
  end
end
