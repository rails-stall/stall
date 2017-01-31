module Stall
  module Adjustable
    extend ActiveSupport::Concern

    included do
      has_many :adjustments, dependent: :destroy, inverse_of: :cart
      accepts_nested_attributes_for :adjustments
    end

    private

    def items
      super.tap do |items|
        adjustments.each do |adjustment|
          items << adjustment
        end
      end
    end
  end
end
