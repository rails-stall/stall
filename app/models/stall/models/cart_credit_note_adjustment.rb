module Stall
  module Models
    module CartCreditNoteAdjustment
      extend ActiveSupport::Concern

      included do
        has_one :credit_note, as: :source, dependent: :nullify
      end
    end
  end
end
