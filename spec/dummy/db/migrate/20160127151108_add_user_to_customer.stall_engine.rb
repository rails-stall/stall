# This migration comes from stall_engine (originally 20160127113619)
class AddUserToCustomer < ActiveRecord::Migration
  def change
    add_reference :stall_customers, :user, polymorphic: true, index: true
  end
end
