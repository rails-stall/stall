class CreateStallPropertyValues < ActiveRecord::Migration
  def change
    create_table :stall_property_values do |t|
      t.references :property, index: true
      t.string :value
      t.integer :position, default: 0

      t.timestamps null: false
    end

    add_foreign_key :stall_property_values, :stall_properties, column: :property_id
  end
end
