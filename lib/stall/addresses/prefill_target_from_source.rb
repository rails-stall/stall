module Stall
  module Addresses
    class PrefillTargetFromSource < Stall::Addresses::CopierBase
      def copy
        prefill_address(:shipping)
        prefill_address(:billing)
      end

      private

      def prefill_address(type)
        if source.send("#{ type }_address") && !target.send("#{ type }_address")
          attributes = duplicate_attributes(source.send("#{ type }_address"))
          target.send("build_#{ type }_address", attributes)
        elsif !target.send("#{ type }_address")
          target.send("build_#{ type }_address")
        end
      end
    end
  end
end
