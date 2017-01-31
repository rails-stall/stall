module Stall
  module Shippable
    extend ActiveSupport::Concern

    included do
      has_one :shipment, dependent: :destroy, inverse_of: :cart
      accepts_nested_attributes_for :shipment
    end

    private

    def items
      super.tap do |items|
        items << shipment if shipment
      end
    end
  end
end
