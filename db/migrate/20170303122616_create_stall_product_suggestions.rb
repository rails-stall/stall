class CreateStallProductSuggestions < ActiveRecord::Migration
  def change
    create_table :stall_product_suggestions do |t|
      t.references :product, index: true
      t.references :suggestion, index: true

      t.timestamps null: false
    end

    add_foreign_key :stall_product_suggestions, :stall_products, column: :product_id
    add_foreign_key :stall_product_suggestions, :stall_products, column: :suggestion_id
  end
end
