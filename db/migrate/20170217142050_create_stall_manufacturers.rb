class CreateStallManufacturers < ActiveRecord::Migration
  def change
    create_table :stall_manufacturers do |t|
      t.string :name
      t.attachment :logo

      t.timestamps null: false
    end
  end
end
