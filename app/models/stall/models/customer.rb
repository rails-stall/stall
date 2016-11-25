module Stall
  module Models
    module Customer
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_customers'

        include Stall::Addressable

        belongs_to :user, polymorphic: true, inverse_of: :customer
        accepts_nested_attributes_for :user

        has_many :product_lists, dependent: :destroy

        validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/ },
                          allow_blank: true

        before_validation :ensure_user_email

        def user_or_default
          user || build_user
        end

        def build_user(attributes = {})
          attributes.reverse_merge!(customer: self)
          self.user = Stall.config.default_user_model.new(attributes)
        end

        private

        def ensure_user_email
          user.email = email unless user && user.email.present?
        end
      end
    end
  end
end
