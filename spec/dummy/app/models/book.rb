class Book < ActiveRecord::Base
  include Stall::Sellable

  belongs_to :category

  validates :title, :price, presence: true
  validates :price, numericality: true
end
