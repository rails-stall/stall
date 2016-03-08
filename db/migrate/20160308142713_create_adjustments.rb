class CreateAdjustments < ActiveRecord::Migration
  def change
    create_table :stall_adjustments do |t|
      t.string     :name,            null: false
      t.monetize   :eot_price,       null: false, currency: { present: false }
      t.monetize   :price,           null: false, currency: { present: false }
      t.decimal    :vat_rate,        null: false
      t.string     :type
      t.references :cart, index: true

      t.timestamps null: false
    end

    add_foreign_key :stall_adjustments, :stall_product_lists, column: :cart_id
  end
end
