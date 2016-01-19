module Stall
  class ProductList < ActiveRecord::Base
    has_secure_token

    has_many :line_items, dependent: :destroy

    belongs_to :customer

    def to_param
      token
    end

    def total_quantity
      line_items.map(&:quantity).sum
    end
  end
end
