# This migration comes from stall_engine (originally 20160118121116)
class CreateStallProductLists < ActiveRecord::Migration
  def change
    create_table :stall_product_lists do |t|
      t.string     :state,    null: false
      t.string     :type,     null: false
      t.string     :currency, null: false
      t.references :customer, index: true
      t.string     :token,    null: false

      t.timestamps            null: false
    end

    add_foreign_key :stall_line_items, :stall_product_lists, column: :product_list_id
  end
end
