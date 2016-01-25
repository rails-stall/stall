module Stall
  class AddressOwnership < ActiveRecord::Base
    belongs_to :address
    accepts_nested_attributes_for :address

    belongs_to :addressable, polymorphic: true
  end
end
