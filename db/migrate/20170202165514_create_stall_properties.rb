class CreateStallProperties < ActiveRecord::Migration
  def change
    create_table :stall_properties do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
