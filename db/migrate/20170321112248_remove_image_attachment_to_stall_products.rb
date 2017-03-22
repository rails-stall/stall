class RemoveImageAttachmentToStallProducts < ActiveRecord::Migration
  def change
    remove_attachment :stall_products, :image
  end
end
