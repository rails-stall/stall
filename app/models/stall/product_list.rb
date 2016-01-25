module Stall
  class ProductList < ActiveRecord::Base
    has_secure_token

    has_many :line_items, dependent: :destroy
    accepts_nested_attributes_for :line_items

    belongs_to :customer, class_name: 'Stall::Customer'
    accepts_nested_attributes_for :customer

    validates :type, presence: true

    after_initialize :ensure_currency
    after_initialize :ensure_state

    def state
      read_attribute(:state).try(:to_sym)
    end

    def reset_state!
      update_column(:state, wizard.steps.first)
    end

    def to_param
      token
    end

    def total_quantity
      line_items.map(&:quantity).sum
    end

    def wizard
      @wizard ||= begin
        wizard_name = Stall.config.default_checkout_wizard

        if (wizard = Stall::Utils.try_load_constant(wizard_name))
          wizard
        else
          raise Stall::Checkout::WizardNotFoundError.new,
            "The checkout wizard #{ wizard_name } was not found. You must generate it " +
            "with `rails g stall:wizard #{ wizard_name.underscore.gsub('_checkout_wizard', '') }`"
        end
      end
    end

    private

    def ensure_currency
      self.currency ||= Money.default_currency
    end

    def ensure_state
      self.state ||= wizard.steps.first
    end
  end
end
