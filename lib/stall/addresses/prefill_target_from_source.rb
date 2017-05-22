module Stall
  module Addresses
    class PrefillTargetFromSource < Stall::Addresses::CopierBase
      def copy
        prefill_address(:shipping)
        prefill_address(:billing)
      end

      private

      def prefill_address(type)
        source.with_actual_address_associations do
          target.with_actual_address_associations do
            source_address = source.send("#{ type }_address")

            if source_address && !target.send("#{ type }_address?")
              attributes = duplicate_attributes(source_address)
              target.send("build_#{ type }_address", attributes)
            elsif !target.send("#{ type }_address?")
              target.send("build_#{ type }_address")
            end
          end
        end
      end
    end
  end
end
