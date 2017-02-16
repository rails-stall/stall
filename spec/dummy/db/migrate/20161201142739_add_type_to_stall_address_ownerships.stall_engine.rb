# This migration comes from stall_engine (originally 20161129101956)
# Before this migration, the AddressOwnership class is removed so we declare it
# here in its minimal version as a temporary fallback allowing us to easily
# migrate our data to the new address direct-relation model
#
class AddressOwnership < ActiveRecord::Base
  self.table_name = 'stall_address_ownerships'
  belongs_to :address
  belongs_to :addressable, polymorphic: true
end

class AddTypeToStallAddressOwnerships < ActiveRecord::Migration
  def up
    change_table :stall_addresses do |t|
      t.string :type
      t.references :addressable, polymorphic: true
    end

    AddressOwnership.find_each do |ownership|
      address = ownership.address
      address.addressable = ownership.addressable

      if ownership.shipping
        address.type = 'ShippingAddress'
        address.save!

        if ownership.billing
          billing_address = BillingAddress.new(addressable: ownership.addressable)
          Stall::Addresses::Copy.new(address, billing_address)
          billing_address.save!
        end
      elsif ownership.billing
        address.type = 'BillingAddress'
        address.save!
      else
        address.destroy
      end
    end

    remove_column :stall_address_ownerships, :billing
    remove_column :stall_address_ownerships, :shipping

    drop_table :stall_address_ownerships
  end

  def down
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

    add_column :stall_address_ownerships, :billing, :boolean
    add_column :stall_address_ownerships, :shipping, :boolean

    change_table :stall_addresses do |t|
      t.remove :type
      t.remove_references :addressable, polymorphic: true
    end
  end
end
