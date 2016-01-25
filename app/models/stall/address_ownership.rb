module Stall
  class AddressOwnership < ActiveRecord::Base
    belongs_to :address
    accepts_nested_attributes_for :address

    belongs_to :addressable, polymorphic: true

    def type_name
      types = []
      types << :billing if billing
      types << :shipping if shipping
      types.join('-')
    end
  end
end
