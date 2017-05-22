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

      def active?
        !paid?
      end
    end
  end
end
