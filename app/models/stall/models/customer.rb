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

        validates :email, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/ }, allow_blank: true

        def user_or_default
          self.user ||= Stall.config.default_user_model.new
        end
      end
    end
  end
end
