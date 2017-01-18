# Joint model between credit notes and adjustments
#
module Stall
  module Models
    module CreditNoteUsage
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_credit_note_usages'

        belongs_to :credit_note
        belongs_to :adjustment, class_name: 'CreditNoteAdjustment'
      end
    end
  end
end
