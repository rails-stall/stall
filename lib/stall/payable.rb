module Stall
  module Payable
    extend ActiveSupport::Concern

    included do
      has_one :payment, dependent: :destroy,
                        inverse_of: :cart,
                        foreign_key: :cart_id
      accepts_nested_attributes_for :payment

      scope :paid, -> {
        joins(:payment).where.not(stall_payments: { paid_at: nil })
      }

      scope :finalized, -> { paid }

      scope :aborted, ->(options = {}) {
        joins('LEFT JOIN stall_payments ON stall_payments.cart_id = stall_product_lists.id')
          .where(stall_payments: { paid_at: nil })
          .older_than(
            options.fetch(:before, Stall.config.aborted_carts_expires_after.ago)
          )
      }

      delegate :paid?, to: :payment, allow_nil: true
    end

    module ClassMethods
      def find_by_payment_transaction_id(transaction_id)
        joins(:payment).where(
          "stall_payments.data->>'transaction_id' = ?",
          transaction_id
        ).first
      end
    end
  end
end
