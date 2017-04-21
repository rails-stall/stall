module Stall
  module WishListHelper
    extend ActiveSupport::Concern

    included do
      if respond_to?(:helper_method)
        helper_method :current_wish_list
      end

      if respond_to?(:after_action)
        after_action :store_wish_list_to_cookies
      end
    end

    def current_wish_list
      RequestStore.store[wish_list_key] ||= load_current_wish_list
    end

    protected

    def current_wish_list_key
      params[:wish_list_key].try(:to_sym) || :default
    end

    def load_current_wish_list(identifier = current_wish_list_key)
      if (wish_list = find_wish_list(identifier))
        return prepare_wish_list(wish_list)
      end

      # If no token was stored or the token does not exist anymore, create a
      # new wish_list and store the new token
      #
      prepare_wish_list(wish_list_class.new(identifier: identifier))
    end

    def prepare_wish_list(wish_list)
      wish_list.tap do
        wish_list.customer = current_customer if current_customer
        # Keep track of potential customer locale switching to allow e-mailing
        # him in his last used locale
        #
        # Only applicable if the locale is an available locale to avoid strange
        # issues with some URL locale management systems that could set the
        # `assets` prefix as a locale, for instance.
        if wish_list.customer && I18n.locale.in?(I18n.available_locales)
          wish_list.customer.locale = I18n.locale
        end

        # Only update locale change for existing wish_lists. New wish_lists don't need
        # to be saved, avoiding each robot or simple visitors to create a
        # wish_list on large shops.
        wish_list.save unless wish_list.new_record?
      end
    end

    def find_wish_list(identifier, ensure_active_wish_list = true)
      if (wish_list_token = cookies.encrypted[wish_list_key(identifier)])
        if (current_wish_list = ProductList.find_by_token(wish_list_token)) &&
           (!ensure_active_wish_list || current_wish_list.active?)
        then
          return current_wish_list
        else
          # Remove any wish_list that can't be fetched, either because it's already
          # paid, or because it was cleaned out
          remove_wish_list_from_cookies(identifier)
          nil
        end
      end
    end

    def remove_wish_list_from_cookies(identifier = current_wish_list_key)
      cookies.delete(wish_list_key(identifier))
    end

    def wish_list_key(identifier = current_wish_list_key, namespace: nil)
      ['stall', 'wish_list', namespace, identifier.to_s].compact.join('.')
    end

    def wish_list_class
      WishList
    end

    def store_wish_list_to_cookies
      if current_wish_list.persisted? && current_wish_list.active?
        store_wish_list_cookie_for(current_wish_list.identifier, current_wish_list)
      end
    end

    def store_wish_list_cookie_for(identifier, wish_list, namespace: nil)
      cookies.encrypted.permanent[wish_list_key(identifier, namespace: namespace)] = wish_list.token
    end
  end
end
