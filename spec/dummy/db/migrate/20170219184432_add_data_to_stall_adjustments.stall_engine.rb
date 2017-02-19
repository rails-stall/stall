# This migration comes from stall_engine (originally 20170131162537)
class AddDataToStallAdjustments < ActiveRecord::Migration
  def change
    add_column :stall_adjustments, :data, :jsonb
  end
end
