module Stall
  module ArchivedPaidCartHelper
    def archived_paid_cart
      RequestStore.store[archived_paid_cart_key] ||= load_archived_paid_cart
    end

    def archived_paid_cart?
      !!archived_paid_cart
    end

    def archive_paid_cart_cookie(identifier)
      cookies.delete(cart_key(identifier))
      store_cart_cookie_for(current_cart.identifier, current_cart, namespace: :paid)
    end

    def archivable_cart?(cart)
      !cart.active? && cart.token != archived_paid_cart_token
    end

    private

    def load_archived_paid_cart
      if (cart_token = archived_paid_cart_token)
        ProductList.find_by_token(archived_paid_cart_token)
      end
    end

    def archived_paid_cart_key
      cart_key(current_cart_key, namespace: :paid)
    end

    def archived_paid_cart_token
      cookies.encrypted[archived_paid_cart_key]
    end
  end
end
