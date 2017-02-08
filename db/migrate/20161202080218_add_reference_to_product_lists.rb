class AddReferenceToProductLists < ActiveRecord::Migration
  def up
    add_column :stall_product_lists, :reference, :string
    add_index :stall_product_lists, :reference, unique: true

    # Migrate all references stored in the JSON data columns to the new
    # reference column
    ProductList.update_all("reference = data->>'reference'")
    # Remove all reference keys in the JSON data columns
    # This is not supported before PG 4.5 so we avoid using it
    # ProductList.update_all("data = (data - 'reference')")
  end

  def down
    remove_index :stall_product_lists, :reference
    remove_column :stall_product_lists, :reference
  end
end
