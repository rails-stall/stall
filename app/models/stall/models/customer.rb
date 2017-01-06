module Stall
  module Models
    module Customer
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_customers'

        include Stall::Addressable

        if Stall.config.default_user_model
          belongs_to :user, polymorphic: true, inverse_of: :customer
          accepts_nested_attributes_for :user

          before_validation :ensure_user_email
        end

        has_many :product_lists, dependent: :destroy

        validates :email, presence: true, 
                          format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/ }

        def user_or_default
          user || build_user
        end

        def build_user(attributes = {})
          (self.user = Stall.config.default_user_model.new(attributes)).tap do
            user.customer = self if user.respond_to?(:customer)
          end if Stall.config.default_user_model
        end

        private

        def ensure_user_email
          user.email = email if user && user.email.blank?
        end
      end
    end
  end
end
