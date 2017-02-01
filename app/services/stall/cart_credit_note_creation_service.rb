module Stall
  class CartCreditNoteCreationService < Stall::BaseService
    attr_reader :cart

    def initialize(cart)
      @cart = cart
    end

    def call
      if cart.remainder? && !adjustment_exists?
        credit_note = create_credit_note!
        create_adjustment_for!(credit_note)
      end
    end

    private

    def adjustment_exists?
      cart.adjustments.any? { |adj| CartCreditNoteAdjustment === adj }
    end

    def create_credit_note!
      cart.customer.credit_notes.create!(amount: cart.remainder)
    end

    def create_adjustment_for!(credit_note)
      name = I18n.t(
        'stall.credit_notes.source_cart_adjustment_label',
        ref: credit_note.reference
      )

      cart.adjustments.create!(
        type: 'CartCreditNoteAdjustment',
        name: name,
        price: credit_note.amount,
        credit_note: credit_note
      )
    end
  end
end
