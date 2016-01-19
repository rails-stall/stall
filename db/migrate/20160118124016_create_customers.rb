class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :stall_customers do |t|
      t.string :email

      t.timestamps null: false
    end

    add_foreign_key :stall_product_lists, :stall_customers, column: :customer_id
  end
end
