module Stall
  class PaymentMethod < ActiveRecord::Base
    has_many :payments, dependent: :nullify

    validates :name, :identifier, presence: true
  end
end
