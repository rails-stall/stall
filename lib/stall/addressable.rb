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
      association(:billing_address).load_target ||
        association(:shipping_address).load_target
    end

    def billing_address?
      billing_address.try(:persisted?) && billing_address.billing?
    end

    # Allow shipping address to fall back to billing address when not filled
    def shipping_address
      association(:shipping_address).load_target ||
        association(:billing_address).load_target
    end

    def shipping_address?
      shipping_address.try(:persisted?) && shipping_address.billing?
    end
  end
end
