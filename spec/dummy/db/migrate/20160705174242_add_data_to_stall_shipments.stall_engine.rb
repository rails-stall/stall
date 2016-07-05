# This migration comes from stall_engine (originally 20160316114649)
class AddDataToStallShipments < ActiveRecord::Migration
  def change
    add_column :stall_shipments, :data, :jsonb
  end
end
