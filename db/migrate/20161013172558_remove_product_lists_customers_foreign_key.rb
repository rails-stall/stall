class RemoveProductListsCustomersForeignKey < ActiveRecord::Migration
  def change
    remove_foreign_key :stall_product_lists, :customer
  end
end
