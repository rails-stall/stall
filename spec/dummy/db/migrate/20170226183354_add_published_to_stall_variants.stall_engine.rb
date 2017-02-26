# This migration comes from stall_engine (originally 20170226183342)
class AddPublishedToStallVariants < ActiveRecord::Migration
  def change
    add_column :stall_variants, :published, :boolean, default: true
  end
end
