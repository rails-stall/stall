module Stall
  module Addresses
    class PrefillTargetFromSource < Stall::Addresses::CopierBase
      def copy
        prefill_shipping_address
        prefill_billing_address
      end

      private

      def prefill_shipping_address
        if source.shipping_address && !target.shipping_address
          target.build_shipping_address(duplicate_attributes(source.shipping_address))
        elsif !target.shipping_address
          target.build_shipping_address
        end
      end

      def prefill_billing_address
        if source.billing_address && !target.billing_address
          target.build_billing_address(duplicate_attributes(source.billing_address))
        elsif !target.billing_address || target.billing_address == target.shipping_address
          target.address_ownership_for(:shipping).billing = false
          target.build_billing_address
        end
      end
    end
  end
end
