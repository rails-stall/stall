# This migration comes from stall_engine (originally 20170206091211)
class AddNameToStallVariants < ActiveRecord::Migration
  def change
    add_column :stall_variants, :name, :string
  end
end
