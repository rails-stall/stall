# This migration comes from stall_engine (originally 20170123125030)
class CreateStallVariants < ActiveRecord::Migration
  def change
    create_table :stall_variants do |t|
      t.references :product, index: true
      t.monetize :price

      t.timestamps null: false
    end

    add_foreign_key :stall_variants, :stall_products, column: 'product_id'
  end
end
