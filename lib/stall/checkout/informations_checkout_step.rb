module Stall
  module Checkout
    class InformationsCheckoutStep < Stall::Checkout::Step
      validations do
        validate :customer_accepts_terms
        validates :customer, :shipping_address, presence: true

        validates :billing_address, presence: true,
          if: :use_another_address_for_billing?

        nested :shipping_address do
          validates :civility, :first_name, :last_name, :address, :country,
                    :zip, :city, presence: true
        end

        nested :billing_address do
          validates :civility, :first_name, :last_name, :address, :country,
                    :zip, :city, presence: true
        end
      end

      def prepare
        ensure_customer
        prefill_addresses_from_customer
        ensure_shipment
        ensure_payment
      end

      def process
        prepare_user_attributes
        cart.assign_attributes(cart_params)
        process_addresses

        return unless valid?

        cart.save.tap do |valid|
          assign_addresses_to_customer!
          calculate_shipping_fee!
        end
      end

      private

      def cart_params
        params.require(:cart).permit(
          :use_another_address_for_billing, :terms,
          :payment_method_id, :shipping_method_id,
          customer_attributes: [
            :email, user_attributes: [
              :password, :password_confirmation
            ]
          ],
          address_ownerships_attributes: [
            :id, :shipping, :billing,
            address_attributes: [
              :id, :civility, :first_name, :last_name, :address,
              :address_details, :country, :zip, :city, :phone
            ]
          ]
        )
      end

      def ensure_customer
        cart.build_customer unless cart.customer
      end

      def ensure_address(type)
        ownership = cart.address_ownership_for(type) || cart.address_ownerships.build(type => true)
        ownership.address || ownership.build_address
      end

      def ensure_billing_address
        return ensure_address(:billing) unless cart_params[:use_another_address_for_billing] == '0'

        # If the form was submitted and we merged both shipping and billing
        # addresses together, we must separate them back to present them to
        # the user form, avoiding to render errors in a form that the user
        # didn't even see before
        ownership = cart.address_ownership_for(:billing)
        ownership.billing = false if ownership.shipping
        ensure_address(:billing)
      end

      def ensure_shipment
        cart.build_shipment unless cart.shipment
      end

      def ensure_payment
        cart.build_payment unless cart.payment
      end

      # Remvove user attributes when no account should be created, for an
      # "anonymous" order creation.
      #
      def prepare_user_attributes
        return if params[:create_account] == '1'

        if cart_params[:customer_attributes] && cart_params[:customer_attributes][:user_attributes]
          cart_params[:customer_attributes].delete(:user_attributes)
        end

        # Remove user from customer to avoid automatic validation of the user
        # if no user should be saved with the customer
        cart.customer.user = nil unless stall_user_signed_in? || cart
      end

      # Merges shipping and billing addresses into one address when the visitor
      # has chosen to use the shipping address for both.
      #
      def process_addresses
        return if use_another_address_for_billing?

        shipping_ownership = cart.address_ownership_for(:shipping)
        billing_ownership = cart.address_ownership_for(:billing)

        return if billing_ownership == shipping_ownership

        # If the user choosed to receive his order by shipping and that he
        # choosed not to fill a billing address, we remove the billing address
        # hidden form that was submitted in the step, and make the shipping
        # address be used as billing address too
        cart.address_ownerships.destroy(billing_ownership) if billing_ownership
        cart.mark_address_ownership_as_billing(shipping_ownership) if shipping_ownership
      end

      # Assigns the shipping fees to the cart based on the selected shipping
      # method
      #
      def calculate_shipping_fee!
        service_class = Stall.config.service_for(:shipping_fee_calculator)
        service_class.new(cart).call
      end

      # Fetches addresses from the customer account and copy them to the
      # cart to pre-fill the fields for the user
      #
      def prefill_addresses_from_customer
        Stall::Addresses::PrefillTargetFromSource.new(cart.customer, cart).copy
      end

      # Copies the addresses filled in the cart to the customer account for
      # next orders informations pre-filling
      #
      def assign_addresses_to_customer!
        Stall::Addresses::CopySourceToTarget.new(cart, cart.customer).copy!
      end

      def use_another_address_for_billing?
        @use_another_address_for_billing ||= cart_params[:use_another_address_for_billing] == '1'
      end

      def customer_accepts_terms
        cart.errors.add(:terms, :accepted) unless cart.terms == '1'
      end
    end
  end
end
