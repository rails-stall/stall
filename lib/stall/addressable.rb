# Provide the common behavior for all models that need to own addresses,
# for billing and shipping
#
module Stall
  module Addressable
    extend ActiveSupport::Concern

    included do
      has_many :address_ownerships, as: :addressable, dependent: :destroy,
                                    inverse_of: :addressable

      has_many :addresses, through: :address_ownerships
      accepts_nested_attributes_for :address_ownerships, allow_destroy: true
    end

    def address_ownership_for(type)
      address_ownerships.find do |ownership|
        ownership.public_send(type)
      end if [:shipping, :billing].include?(type.to_sym)
    end

    # Provide billing and shipping address fetching and assigning shortcuts by
    # using the address ownerships
    #
    [:shipping, :billing].each do |type|
      instance_variable_name = :"@#{ type }_address"

      define_method(:"#{ type }_address=") do |address|
        ownership = address_ownership_for(type) || address_ownerships.build(type => true)
        ownership.address = address
        instance_variable_set(instance_variable_name, address)
      end

      define_method(:"build_#{ type }_address") do |attributes = {}|
        if (ownership = address_ownership_for(type))
          ownership.send(:"#{ type }=", false)
        end

        ownership = address_ownerships.build(type => true)
        address = ownership.build_address(attributes)
        instance_variable_set(instance_variable_name, address)
      end

      define_method(:"#{ type }_address") do
        if (address = instance_variable_get(instance_variable_name))
          return address
        end

        if (ownership = address_ownership_for(type))
          instance_variable_set(instance_variable_name, ownership.address)
        end
      end

      define_method(:"#{ type }_address_attributes=") do |attributes|
        attributes.delete(:id)

        ownership = address_ownership_for(type) || address_ownerships.build(type => true)
        address = ownership.address || ownership.build_address
        address.assign_attributes(attributes)
        instance_variable_set(instance_variable_name, address)
      end

      define_method(:"mark_address_ownership_as_#{ type }") do |ownership|
        ownership.send(:"mark_as_#{ type }").tap do
          instance_variable_set(instance_variable_name, ownership.address)
        end
      end
    end
  end
end
