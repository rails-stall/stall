class CreateStallLineItems < ActiveRecord::Migration
  def change
    create_table :stall_line_items do |t|
      t.references :sellable,     polymorphic: true, index: true
      t.references :product_list, index: true

      t.string  :name,            null: false
      t.integer :quantity,        null: false
      t.decimal :unit_eot_price,  null: false
      t.decimal :unit_price,      null: false
      t.decimal :eot_price,       null: false
      t.decimal :price,           null: false
      t.decimal :vat_rate,        null: false
      t.json    :data

      t.timestamps                null: false
    end
  end
end
