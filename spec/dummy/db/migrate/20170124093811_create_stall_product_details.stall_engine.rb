# This migration comes from stall_engine (originally 20170123143704)
class CreateStallProductDetails < ActiveRecord::Migration
  def change
    create_table :stall_product_details do |t|
      t.references :product, index: true
      t.string :name
      t.text :content
      t.integer :position, default: 0

      t.timestamps null: false
    end 

    add_foreign_key :stall_product_details, :stall_products, column: 'product_id'
  end
end
