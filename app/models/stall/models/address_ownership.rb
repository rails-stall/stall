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

      [:shipping, :billing].each do |type|
        define_method(:"mark_as_#{ type }") do
          if (ownership = addressable.address_ownership_for(type))
            ownership.send(:"#{ type }=", false)
          end

          send(:"#{ type }=", true)
        end
      end
    end
  end
end
