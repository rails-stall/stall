class Book < ActiveRecord::Base
  include Stall::Sellable

  validates :title, :price, presence: true
  validates :price, numericality: true
end
