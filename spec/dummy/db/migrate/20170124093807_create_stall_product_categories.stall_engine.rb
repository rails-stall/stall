# This migration comes from stall_engine (originally 20170123123115)
class CreateStallProductCategories < ActiveRecord::Migration
  def change
    create_table :stall_product_categories do |t|
      t.string :name
      t.text :slug
      t.integer :position, default: 0
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
