module Stall
  module Checkout
    class InformationsCheckoutStep < Stall::Checkout::Step
      def prepare
        ensure_customer
        ensure_address(:billing)
        ensure_address(:shipping)
      end

      def process
        cart.assign_attributes(cart_params)
        process_addresses
        save
      end

      private

      def ensure_customer
        cart.build_customer unless cart.customer
      end

      def ensure_address(type)
        unless cart.address_ownership_for(type)
          ownership = cart.address_ownerships.build(type => true)
          ownership.build_address
        end
      end

      def process_addresses
        unless params[:use_another_address_for_billing]
          # Remove submitted billing address
          if (billing_ownership = cart.address_ownership_for(:billing))
            cart.address_ownerships.destroy(billing_ownership)
          end

          # Set shipping address as the billing one
          if (shipping_ownership = cart.address_ownership_for(:shipping))
            shipping_ownership.billing = true
          end
        end
      end
    end
  end
end
