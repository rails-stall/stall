# This migration comes from stall_engine (originally 20170202165514)
class CreateStallProperties < ActiveRecord::Migration
  def change
    create_table :stall_properties do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
