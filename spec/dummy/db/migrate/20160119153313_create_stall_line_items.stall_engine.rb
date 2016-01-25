# This migration comes from stall_engine (originally 20151103154313)
class CreateStallLineItems < ActiveRecord::Migration
  def change
    create_table :stall_line_items do |t|
      t.references :sellable,        polymorphic: true, index: true
      t.references :product_list,    index: true

      t.string     :name,            null: false
      t.integer    :quantity,        null: false
      t.monetize   :unit_eot_price,  null: false, currency: { present: false }
      t.monetize   :unit_price,      null: false, currency: { present: false }
      t.monetize   :eot_price,       null: false, currency: { present: false }
      t.monetize   :price,           null: false, currency: { present: false }
      t.decimal    :vat_rate,        null: false
      t.json       :data

      t.timestamps                   null: false
    end
  end
end
