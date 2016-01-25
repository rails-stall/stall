module Stall
  class Payment < ActiveRecord::Base
    belongs_to :payment_method
    belongs_to :cart

    validates :cart, :payment_method, presence: true
  end
end
