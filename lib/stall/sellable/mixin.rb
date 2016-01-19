module Stall
  module Sellable
    module Mixin
      extend ActiveSupport::Concern

      def sellable?
        false
      end

      module ClassMethods
        def acts_as_sellable
          include Stall::Sellable::Model
        end
      end
    end
  end
end
