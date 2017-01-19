module Stall
  class CreditUsageService < Stall::BaseService
    class NotEnoughCreditError < StandardError; end

    attr_reader :cart, :params

    def initialize(cart, params = {})
      @cart = cart
      @params = params
    end

    def call
      available_credit_notes.reduce(amount) do |missing_amount, credit_note|
        break true if missing_amount.to_d == 0

        used_amount = [credit_note.remaining_amount, missing_amount].min
        add_adjustment(used_amount, credit_note)

        missing_amount - used_amount
      end
    rescue NotEnoughCreditError
      false
    end

    private

    def amount
      @amount ||= if params[:amount]
        cents = BigDecimal.new(params[:amount]) * 100

        Money.new(cents, cart.currency).tap do |amount|
          raise NotEnoughCreditError if amount > credit
        end
      else
        [credit, cart.total_price].min
      end
    end

    def credit
      @credit ||= cart.customer.try(:credit) || Money.new(0, cart.currency)
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
  end
end
