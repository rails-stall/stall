module Stall
  module Models
    module CreditNoteAdjustment
      extend ActiveSupport::Concern

      included do
        has_one :credit_note_usage, foreign_key: :adjustment_id,
                                    dependent: :destroy
        has_one :credit_note, through: :credit_note_usage
      end
    end
  end
end
