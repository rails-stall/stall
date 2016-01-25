module Stall
  class ShippingMethod < ActiveRecord::Base
    has_many :shipments, dependent: :nullify
  end
end
