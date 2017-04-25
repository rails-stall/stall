module Stall
  module Models
    module Cart
      extend ActiveSupport::Concern

      included do
        include Stall::Addressable
        include Stall::Payable
        include Stall::Shippable
        include Stall::Adjustable

        attr_accessor :terms
      end

      def total_weight
        line_items.map(&:total_weight).sum
      end

      def active?
        !paid?
      end
    end
  end
end
