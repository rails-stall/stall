module Stall
  module Models
    module ProductList
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_product_lists'

        include Stall::DefaultCurrencyManager
        include Stall::ReferenceManager
        include Stall::TotalPricesManager

        has_secure_token

        has_many :line_items, -> { ordered }, dependent: :destroy
        accepts_nested_attributes_for :line_items, allow_destroy: true

        belongs_to :customer
        accepts_nested_attributes_for :customer

        has_many :generated_credit_notes, as: :source,
                                          class_name: 'CreditNote',
                                          dependent: :nullify

        validates :type, presence: true

        after_initialize :ensure_state

        before_save :save_customer_if_changed

        scope :empty, -> {
          joins(
            'LEFT JOIN stall_line_items ' \
            'ON stall_product_lists.id = stall_line_items.product_list_id'
          ).where(stall_line_items: { id: nil })
        }

        scope :filled, -> { joins(:line_items) }

        scope :older_than, ->(date) {
          where('stall_product_lists.updated_at < ?', date)
        }
      end

      def state
        read_attribute(:state).try(:to_sym)
      end

      def reset_state!
        self.state = wizard.steps.first
        save(validate: false) if persisted?
      end

      def to_param
        persisted? ? token : 'empty-cart'
      end

      def subtotal
        ensure_money(line_items.map(&:price).sum)
      end

      def eot_subtotal
        ensure_money(line_items.map(&:eot_price).sum)
      end

      def total_quantity
        line_items.map(&:quantity).compact.sum
      end

      def wizard
        @wizard ||= self.class.wizard
      end

      def checkoutable?
        line_items.length > 0
      end

      def active?
        true
      end

      private

      def ensure_state
        self.state ||= (wizard.try(:steps).try(:first) || 'pending')
      end

      def items
        line_items.to_a
      end

      def save_customer_if_changed
        customer.save if customer && customer.changed?
      end

      module ClassMethods
        # The .aborted and .finalized scopes cannot be declared as actual rails
        # scopes since subclasses that override the .wizard method wouldn't
        # be taken into account, scopes being executed in the context of the
        # declaring class
        #
        def aborted(options = {})
          where.not(state: wizard.steps.last)
            .older_than(options.fetch(:before, 1.day.ago))
        end

        def finalized
          where(state: wizard.steps.last)
        end

        def wizard
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
    end
  end
end
