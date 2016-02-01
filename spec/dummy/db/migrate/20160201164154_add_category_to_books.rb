class AddCategoryToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :category, index: true, foreign_key: true
  end
end
