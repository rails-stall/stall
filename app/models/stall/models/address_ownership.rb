module Stall
  module Models
    module AddressOwnership
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_address_ownerships'

        belongs_to :address
        accepts_nested_attributes_for :address

        belongs_to :addressable, polymorphic: true
      end
    end
  end
end
