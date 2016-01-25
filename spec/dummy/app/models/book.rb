class Book < ActiveRecord::Base
  acts_as_sellable

  validates :title, :price, presence: true
  validates :price, numericality: true
end
