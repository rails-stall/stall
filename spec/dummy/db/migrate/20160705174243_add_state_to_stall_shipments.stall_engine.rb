# This migration comes from stall_engine (originally 20160317141632)
class AddStateToStallShipments < ActiveRecord::Migration
  def change
    add_column :stall_shipments, :state, :integer, default: 0
  end
end
