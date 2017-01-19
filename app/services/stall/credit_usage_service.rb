module Stall
  class CreditUsageService < Stall::BaseService
    attr_reader :cart, :params

    def initialize(cart, params = {})
      @cart = cart
      @params = params
    end

    def call
      return false unless enough_credit?

      clean_previous_credit_note_adjustments!

      available_credit_notes.reduce(amount) do |missing_amount, credit_note|
        break true if missing_amount.to_d == 0

        used_amount = [credit_note.remaining_amount, missing_amount].min
        add_adjustment(used_amount, credit_note)

        missing_amount - used_amount
      end
    end

    private

    def amount
      @amount ||= if params[:amount]
        cents = BigDecimal.new(params[:amount]) * 100
        Money.new(cents, cart.currency)
      else
        [credit, cart.total_price].min
      end
    end

    def credit
      @credit ||= cart.customer.try(:credit) || Money.new(0, cart.currency)
    end

    def enough_credit?
      amount <= credit
    end

    def available_credit_notes
      @available_credit_notes ||= cart.customer.credit_notes.select(&:with_remaining_money?)
    end

    def add_adjustment(amount, credit_note)
      cart.adjustments.create!(
        type: 'CreditNoteAdjustment',
        name: I18n.t('stall.credit_notes.adjustment_label', ref: credit_note.reference),
        price: -amount,
        credit_note: credit_note
      )
    end

    def clean_previous_credit_note_adjustments!
      credit_note_adjustments = cart.adjustments.select do |adjustment|
        CreditNoteAdjustment === adjustment
      end

      credit_note_adjustments.each do |adjustment|
        cart.adjustments.destroy(adjustment)
      end
    end
  end
end
