# This migration comes from stall_engine (originally 20161202080218)
class AddReferenceToProductLists < ActiveRecord::Migration
  def up
    add_column :stall_product_lists, :reference, :string
    add_index :stall_product_lists, :reference, unique: true

    # Migrate all references stored in the JSON data columns to the new
    # reference column
    Cart.update_all("reference = data->>'reference'")
    # Remove all reference keys in the JSON data columns
    Cart.update_all("data = (data - 'reference')")
  end

  def down
    # Restore references to the JSON data column reference key
    Cart.update_all("data = (COALESCE(data, '{}'::jsonb) || ('{\"reference\": \"' || reference || '\"}')::jsonb)")

    remove_index :stall_product_lists, :reference
    remove_column :stall_product_lists, :reference
  end
end
