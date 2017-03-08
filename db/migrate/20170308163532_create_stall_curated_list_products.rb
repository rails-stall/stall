class CreateStallCuratedListProducts < ActiveRecord::Migration
  def change
    create_table :stall_curated_list_products do |t|
      t.references :product, index: true
      t.references :curated_product_list
      t.integer :position, default: 0

      t.timestamps null: false
    end

    add_foreign_key :stall_curated_list_products, :stall_products, column: :product_id
    add_foreign_key :stall_curated_list_products, :stall_products, column: :curated_product_list_id
  end
end
