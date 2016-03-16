module Stall
  module CartHelper
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :current_cart, :current_cart_key
      end
    end

    def current_cart
      RequestStore.store[cart_key] ||= load_current_cart
    end

    protected

    def current_cart_key
      params[:cart_key].try(:to_sym) || :default
    end

    def load_current_cart(type = current_cart_key)
      if (cart = find_cart(type))
        return cart
      end

      # If no token was stored or the token does not exist anymore, create a
      # new cart and store the new token
      #
      Cart.create!(identifier: type).tap do |cart|
        session[cart_key(type)] = cart.token
      end
    end

    def find_cart(type)
      if (cart_token = session[cart_key(type)])
        if (current_cart = Cart.find_by_token(cart_token))
          return current_cart
        end
      end
    end

    def remove_cart_from_session(type = current_cart_key)
      session.delete(cart_key(type))
    end

    def cart_key(identifier = current_cart_key)
      ['stall', 'cart', identifier.to_s].join('.')
    end
  end
end
