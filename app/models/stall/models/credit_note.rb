module Stall
  module Models
    module CreditNote
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_credit_notes'

        include Stall::Priceable
        include Stall::DefaultCurrencyManager
        include Stall::ReferenceManager

        monetize :eot_amount_cents, :amount_cents,
                 with_model_currency: :currency, allow_nil: true

        belongs_to :customer
        belongs_to :source, polymorphic: true

        has_many :credit_note_usages, dependent: :destroy
        has_many :adjustments, through: :credit_note_usages

        validates :amount, :customer, presence: true

        def amount_with_eot_management=(value)
          (self.amount_without_eot_management = value).tap do
            self.eot_amount = amount / vat_coefficient
          end
        end

        # TODO : Check if we can use Module#prepend here without getting too
        #        complex
        #
        alias_method :amount_without_eot_management=, :amount=
        alias_method :amount=, :amount_with_eot_management=
      end

      def remaining_amount
        amount - adjustments.map(&:price).sum
      end

      def vat_rate
        read_attribute(:vat_rate) || write_attribute(:vat_rate, Stall.config.vat_rate)
      end

      def with_remaining_money?
        remaining_amount.to_d > 0
      end
    end
  end
end
