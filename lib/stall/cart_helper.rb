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

    def load_current_cart(identifier = current_cart_key)
      if (cart = find_cart(identifier))
        return cart
      end

      # If no token was stored or the token does not exist anymore, create a
      # new cart and store the new token
      #
      cart_class.create!(identifier: identifier).tap do |cart|
        session[cart_key(identifier)] = cart.token
      end
    end

    def find_cart(identifier)
      if (cart_token = session[cart_key(identifier)])
        if (current_cart = ProductList.find_by_token(cart_token))
          return current_cart
        end
      end
    end

    def remove_cart_from_session(identifier = current_cart_key)
      session.delete(cart_key(identifier))
    end

    def cart_key(identifier = current_cart_key)
      ['stall', 'cart', identifier.to_s].join('.')
    end

    def cart_class
      Cart
    end
  end
end
