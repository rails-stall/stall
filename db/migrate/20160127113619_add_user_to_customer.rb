class AddUserToCustomer < ActiveRecord::Migration
  def change
    add_reference :stall_customers, :user, polymorphic: true, index: true
  end
end
