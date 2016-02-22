module Stall
  module Models
    module ShippingMethod
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_shipping_methods'

        has_many :shipments, dependent: :nullify

        scope :ordered, -> { order('stall_shipping_methods.name ASC') }
      end
    end
  end
end
