module Stall
  module Models
    module Customer
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_customers'

        include Stall::Addressable

        belongs_to :user, polymorphic: true, inverse_of: :customer
        accepts_nested_attributes_for :user

        before_validation :ensure_user_email

        has_many :product_lists, dependent: :destroy
        has_many :credit_notes, dependent: :destroy
        has_many :carts, dependent: :nullify

        validates :email, presence: true,
                          format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/ }

        def user_or_default
          user || build_user
        end

        def build_user(attributes = {})
          self.user = ::User.new(attributes.merge(customer: self))
        end

        def credit(currency = Stall.config.default_currency)
          credit_notes.for_currency(currency).map(&:remaining_amount).sum
        end

        def credit?(currency = Stall.config.default_currency)
          credit(currency).to_d > 0
        end

        private

        def ensure_user_email
          user.email = email if user && user.email.blank?
        end
      end
    end
  end
end
