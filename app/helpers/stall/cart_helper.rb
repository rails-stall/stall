module Stall
  module CartHelper
    def current_cart
      RequestStore.store[cart_store_key_for(:default)] ||= load_current_cart
    end

    private

    def load_current_cart
      if (cart_token = session[cart_store_key_for(:default)])
        if (current_cart = Stall::Cart.find_by_token(cart_token))
          return current_cart
        end
      end

      # If no token was stored or the token does not exist anymore, create a
      # new cart and store the new token
      #
      Stall::Cart.create!.tap do |cart|
        session[cart_store_key_for(:default)] = cart.token
      end
    end

    def cart_store_key_for(identifier)
      ['stall', 'cart', identifier.to_s].join('.')
    end
  end
end
