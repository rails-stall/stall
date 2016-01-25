class CreateStallShipments < ActiveRecord::Migration
  def change
    create_table :stall_shipments do |t|
      t.references  :cart,             index: true
      t.references  :shipping_method,  index: true
      t.monetize    :price,            currency: { present: false }
      t.monetize    :eot_price,        currency: { present: false }
      t.decimal     :vat_rate
      t.datetime    :sent_at

      t.timestamps  null: false
    end

    add_foreign_key :stall_shipments, :stall_product_lists, column: :cart_id
    add_foreign_key :stall_shipments, :stall_shipping_methods, column: :shipping_method_id
  end
end
