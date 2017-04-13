class AddStockToStallVariants < ActiveRecord::Migration
  def change
    add_column :stall_variants, :stock, :integer, default: 0
  end
end
