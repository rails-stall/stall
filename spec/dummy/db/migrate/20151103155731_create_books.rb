class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :description
      t.decimal :price, precision: 11, scale: 2

      t.timestamps null: false
    end
  end
end
