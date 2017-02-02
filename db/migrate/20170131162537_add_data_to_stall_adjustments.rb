class AddDataToStallAdjustments < ActiveRecord::Migration
  def change
    add_column :stall_adjustments, :data, :jsonb
  end
end
