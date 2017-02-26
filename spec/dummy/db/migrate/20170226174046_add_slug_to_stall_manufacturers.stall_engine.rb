# This migration comes from stall_engine (originally 20170221094450)
class AddSlugToStallManufacturers < ActiveRecord::Migration
  def change
    add_column :stall_manufacturers, :slug, :text
  end
end
