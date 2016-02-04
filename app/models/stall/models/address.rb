module Stall
  module Models
    module Address
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_addresses'

        has_one :addressable_ownership, dependent: :destroy
      end
    end
  end
end
