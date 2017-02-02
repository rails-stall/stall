class CreateStallProducts < ActiveRecord::Migration
  def change
    create_table :stall_products do |t|
      t.string :name
      t.attachment :image
      t.text :description
      t.text :slug
      t.integer :position
      t.boolean :visible, default: true
      t.references :product_category, index: true

      t.timestamps null: false
    end

    add_foreign_key :stall_products, :stall_product_categories, column: 'product_category_id'
  end
end
