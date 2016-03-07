class AddStateToStallAddresses < ActiveRecord::Migration
  def change
    add_column :stall_addresses, :state, :string
  end
end
