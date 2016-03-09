class AddIdentifierToStallProductLists < ActiveRecord::Migration
  def change
    add_column :stall_product_lists, :identifier, :string, null: false, default: 'default'
  end
end
