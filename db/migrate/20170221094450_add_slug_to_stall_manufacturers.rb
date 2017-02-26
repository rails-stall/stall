class AddSlugToStallManufacturers < ActiveRecord::Migration
  def change
    add_column :stall_manufacturers, :slug, :text
  end
end
