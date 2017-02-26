class AddPublishedToStallVariants < ActiveRecord::Migration
  def change
    add_column :stall_variants, :published, :boolean, default: true
  end
end
