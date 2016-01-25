class CreateStallAddressOwnerships < ActiveRecord::Migration
  def change
    create_table :stall_address_ownerships do |t|
      t.references :address,     index: true
      t.references :addressable, polymorphic: true
      t.boolean    :billing,     default: false
      t.boolean    :shipping,    default: false

      t.timestamps null: false

      t.index      [:addressable_id, :addressable_type],
                   name: :index_address_ownerships_on_addressable_type_and_id

      t.foreign_key :stall_addresses, column: :address_id
    end
  end
end
