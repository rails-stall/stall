class AddStateToStallShipments < ActiveRecord::Migration
  def change
    add_column :stall_shipments, :state, :integer, default: 0
  end
end
