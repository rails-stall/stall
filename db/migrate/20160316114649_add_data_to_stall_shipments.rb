class AddDataToStallShipments < ActiveRecord::Migration
  def change
    add_column :stall_shipments, :data, :jsonb
  end
end
