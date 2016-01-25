class CreateStallPayments < ActiveRecord::Migration
  def change
    create_table :stall_payments do |t|
      t.references :payment_method, index: true
      t.references :cart, index: true
      t.datetime   :paid_at
      t.json       :data

      t.timestamps null: false
    end

    add_foreign_key :stall_payments, :stall_product_lists, column: :cart_id
    add_foreign_key :stall_payments, :stall_payment_methods, column: :payment_method_id
  end
end
