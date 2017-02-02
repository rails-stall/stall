class CreateCreditNotes < ActiveRecord::Migration
  def change
    create_table :stall_credit_notes do |t|
      t.string     :reference
      t.references :customer,    index: true
      t.string     :currency
      t.monetize   :eot_amount,  null: false,        currency: { present: false }
      t.monetize   :amount,      null: false,        currency: { present: false }
      t.decimal    :vat_rate,    precision: 11,      scale: 2
      t.references :source,      polymorphic: true,  index: true

      t.timestamps null: false
    end

    add_foreign_key :stall_credit_notes, :stall_customers, column: :customer_id
  end
end
