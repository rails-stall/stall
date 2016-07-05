# This migration comes from stall_engine (originally 20160307142924)
class AddStateToStallAddresses < ActiveRecord::Migration
  def change
    add_column :stall_addresses, :state, :string
  end
end
