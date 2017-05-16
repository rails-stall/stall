# Provide the common behavior for all models that need to own addresses,
# for billing and shipping
#
module Stall
  module Addressable
    extend ActiveSupport::Concern

    included do
      has_one :shipping_address, as: :addressable,
                                 class_name: 'ShippingAddress',
                                 dependent: :destroy,
                                 inverse_of: :addressable
      accepts_nested_attributes_for :shipping_address, allow_destroy: true

      has_one :billing_address, as: :addressable,
                                class_name: 'BillingAddress',
                                dependent: :destroy,
                                inverse_of: :addressable
      accepts_nested_attributes_for :billing_address, allow_destroy: true

      attr_accessor :use_another_address_for_billing
    end

    # Allow billing address to fall back to shipping address when not filled
    def billing_address
      if (billing_address = association(:billing_address).load_target)
        billing_address
      elsif !@_force_actual_address_association
        association(:shipping_address).load_target
      end
    end

    def billing_address?
      billing_address.try(:persisted?) && billing_address.billing?
    end

    def billing_address_attributes=(attributes)
      with_actual_address_associations do
        assign_nested_attributes_for_one_to_one_association(:billing_address, attributes)
      end
    end

    # Allow shipping address to fall back to billing address when not filled
    def shipping_address
      if (shipping_address = association(:shipping_address).load_target)
        shipping_address
      elsif !@_force_actual_address_association
        association(:billing_address).load_target
      end
    end

    def shipping_address?
      shipping_address.try(:persisted?) && shipping_address.billing?
    end

    def shipping_address_attributes=(attributes)
      with_actual_address_associations do
        assign_nested_attributes_for_one_to_one_association(:shipping_address, attributes)
      end
    end

    # Allow forcing actual address associations to be retrieved, thus disabling
    # addresses fallback for the duration of the block.
    #
    # This is used for nested attributes assignation which calls the
    # associations reader directly, which happen to merge addresses when
    # both billing and shipping addresses are assigned at the same time.
    #
    def with_actual_address_associations
      @_force_actual_address_association = true
      yield
      @_force_actual_address_association = false
    end
  end
end
