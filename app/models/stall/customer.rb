module Stall
  class Customer < ActiveRecord::Base
    include Stall::Addressable

    belongs_to :user, polymorphic: true, inverse_of: :customer
    accepts_nested_attributes_for :user
  end
end
