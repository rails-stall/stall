class AddNameToStallVariants < ActiveRecord::Migration
  def change
    add_column :stall_variants, :name, :string
  end
end
