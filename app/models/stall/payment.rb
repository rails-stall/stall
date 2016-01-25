module Stall
  class Payment < ActiveRecord::Base
    store_accessor :data, :transaction_id

    belongs_to :payment_method
    belongs_to :cart

    validates :cart, :payment_method, presence: true

    def pay!
      update_attributes!(paid_at: Time.now)
    end
  end
end
