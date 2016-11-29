# Allows copying
module Stall
  module Addresses
    class Copy < Stall::Addresses::CopierBase
      def copy
        target.assign_attributes(duplicate_attributes(source))
      end
    end
  end
end
