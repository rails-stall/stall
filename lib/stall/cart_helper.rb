module Stall
  module CartHelper
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :current_cart, :current_cart_key
      end

      if respond_to?(:after_action)
        after_action :store_cart_to_cookies
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
        cart.customer.locale = I18n.locale if cart.customer

        # Only update locale change for existing carts. New carts don't need
        # to be saved, avoiding each robot or simple visitors to create a
        # cart on large shops.
        cart.save unless cart.new_record?
      end
    end

    def find_cart(identifier)
      if (cart_token = cookies.encrypted[cart_key(identifier)])
        if (current_cart = ProductList.find_by_token(cart_token)) && current_cart.active?
          return current_cart
        else
          # Remove any cart that can't be fetched, either because it's already
          # paid, or because it was cleaned out
          remove_cart_from_cookies(identifier)
          nil
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

    def store_cart_to_cookies
      if current_cart.persisted?
        store_cart_cookie_for(current_cart.identifier, current_cart)
      end
    end

    def store_cart_cookie_for(identifier, cart)
      cookies.encrypted.permanent[cart_key(identifier)] = cart.token
    end
  end
end
