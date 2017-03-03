class AddPositionToStallManufacturers < ActiveRecord::Migration
  def change
    add_column :stall_manufacturers, :position, :integer, default: 0
  end
end
