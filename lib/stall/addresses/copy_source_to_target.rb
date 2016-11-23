# Allows copying
module Stall
  module Addresses
    class CopySourceToTarget < Stall::Addresses::CopierBase
      def copy!
        copy
        target.save!
      end

      def copy
        copy_shipping_address
        copy_billing_address
      end

      private

      def copy_shipping_address
        # Update or create target's shipping address with source's shipping
        # address attributes
        if target.shipping_address
          target.shipping_address.assign_attributes(duplicate_attributes(source.shipping_address))
        else
          target.build_shipping_address(duplicate_attributes(source.shipping_address))
        end
      end

      def copy_billing_address
        # If the source uses the same address for shipping and billing, we
        # reproduce this behavior ont the target
        if source.shipping_address == source.billing_address
          shipping_ownership = target.address_ownership_for(:shipping)
          target.mark_address_ownership_as_billing(shipping_ownership)
        # If the source has a separate billing address, we update or create the
        # target's billing address with the source's one attributes
        else
          if target.billing_address
            target.billing_address.assign_attributes(duplicate_attributes(source.billing_address))
          else
            target.build_billing_address(duplicate_attributes(source.billing_address))
          end
        end
      end
    end
  end
end
