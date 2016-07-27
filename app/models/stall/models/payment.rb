module Stall
  module Models
    module Payment
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_payments'

        store_accessor :data, :transaction_id

        belongs_to :payment_method
        belongs_to :cart

        validates :cart, :payment_method, presence: true

        scope :pending, -> { where(paid_at: nil) }
        scope :paid, -> { where.not(paid_at: nil) }
      end

      def pay!
        update_attributes!(paid_at: Time.now)
      end

      def paid?
        paid_at != nil
      end

      def state
        paid? ? :paid : :pending
      end
    end
  end
end
