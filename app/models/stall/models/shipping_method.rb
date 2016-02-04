module Stall
  module Models
    module ShippingMethod
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_shipping_methods'

        has_many :shipments, dependent: :nullify
      end
    end
  end
end
