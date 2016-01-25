module Stall
  class Address < ActiveRecord::Base
    has_one :addressable_ownership, dependent: :destroy
  end
end
