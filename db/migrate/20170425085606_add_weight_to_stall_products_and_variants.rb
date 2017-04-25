class AddWeightToStallProductsAndVariants < ActiveRecord::Migration
  def change
    add_column :stall_products, :weight, :integer, default: 0
    add_column :stall_variants, :weight, :integer, default: 0
  end
end
