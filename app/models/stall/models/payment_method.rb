module Stall
  module Models
    module PaymentMethod
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_payment_methods'

        has_many :payments, dependent: :nullify

        validates :name, :identifier, presence: true
      end
    end
  end
end
