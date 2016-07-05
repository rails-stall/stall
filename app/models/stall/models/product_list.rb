module Stall
  module Models
    module ProductList
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_product_lists'

        store_accessor :data, :reference

        has_secure_token

        has_many :line_items, -> { ordered }, dependent: :destroy
        accepts_nested_attributes_for :line_items, allow_destroy: true

        belongs_to :customer
        accepts_nested_attributes_for :customer

        validates :type, presence: true

        after_initialize :ensure_currency
        after_initialize :ensure_state

        after_save :ensure_reference, on: :create
      end

      def state
        read_attribute(:state).try(:to_sym)
      end

      def reset_state!
        update_column(:state, wizard.steps.first)
      end

      def to_param
        token
      end

      def total_price
        price = items.map(&:price).sum
        price = Money.new(price, currency) unless Money === price
        price
      end

      def total_eot_price
        items.map(&:eot_price).sum
      end

      def total_vat
        items.map(&:vat).sum
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
        self.state ||= (wizard&.steps.first || 'pending')
      end

      def items
        line_items.to_a
      end

      def ensure_reference
        unless reference.present?
          reference = [Time.now.strftime('%Y%m%d'), ('%05d' % id)].join('-')
          self.reference = reference
          save(validate: false)
        end
      end

      module ClassMethods
        def find_by_reference(reference)
          where("data->>'reference' = ?", reference).first
        end
      end
    end
  end
end
