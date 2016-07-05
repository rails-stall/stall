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
        return prepare_cart(cart)
      end

      # If no token was stored or the token does not exist anymore, create a
      # new cart and store the new token
      #
      prepare_cart(cart_class.new(identifier: identifier))
    end

    def prepare_cart(cart)
      cart.tap do |cart|
        # Keep track of potential customer locale switching to allow e-mailing
        # him in his last used locale
        cart.customer&.locale = I18n.locale
        cart.save

        store_cart_cookie_for(cart.identifier, cart)
      end
    end

    def find_cart(identifier)
      if (cart_token = cookies[cart_key(identifier)])
        if (current_cart = ProductList.find_by_token(cart_token))
          return current_cart
        end
      end
    end

    def remove_cart_from_cookies(identifier = current_cart_key)
      cookies.delete(cart_key(identifier))
    end

    def cart_key(identifier = current_cart_key)
      ['stall', 'cart', identifier.to_s].join('.')
    end

    def cart_class
      Cart
    end

    def store_cart_cookie_for(identifier, cart)
      cookies.permanent[cart_key(identifier)] = cart.token
    end
  end
end
