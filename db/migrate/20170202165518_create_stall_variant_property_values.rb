class CreateStallVariantPropertyValues < ActiveRecord::Migration
  def change
    create_table :stall_variant_property_values do |t|
      t.references :property_value, index: true
      t.references :variant, index: true

      t.timestamps null: false
    end

    add_foreign_key :stall_variant_property_values, :stall_property_values, column: :property_value_id
    add_foreign_key :stall_variant_property_values, :stall_variants, column: :variant_id
  end
end
