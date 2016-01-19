class CreateStallProductLists < ActiveRecord::Migration
  def change
    create_table :stall_product_lists do |t|
      t.integer :state, default: 0
      t.string :type
      t.references :customer, index: true
      t.string :token

      t.timestamps null: false
    end

    add_foreign_key :stall_line_items, :product_lists
  end
end
