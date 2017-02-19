# This migration comes from stall_engine (originally 20170217143037)
class AddManufacturerToStallProducts < ActiveRecord::Migration
  def change
    add_reference :stall_products, :manufacturer, index: true
    add_foreign_key :stall_products, :stall_manufacturers, column: :manufacturer_id
  end
end
