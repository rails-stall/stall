# Allows copying
module Stall
  module Addresses
    class CopySourceToTarget < Stall::Addresses::CopierBase
      def copy!
        copy
        target.save!
      end

      def copy
        copy_address(:shipping)
        copy_address(:billing)
      end

      private

      # Update or create target address with source attributes
      #
      def copy_address(type)
        address = if target.send(:"#{ type }_address?")
          target.send(:"#{ type }_address")
        else
          target.send(:"build_#{ type }_address")
        end

        if source.send(:"#{ type }_address?")
          attributes = duplicate_attributes(source.send(:"#{ type }_address"))
          address.assign_attributes(attributes)
        else
          address.try(:mark_for_destruction)
        end
      end
    end
  end
end
