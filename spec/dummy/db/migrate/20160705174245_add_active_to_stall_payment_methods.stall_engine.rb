# This migration comes from stall_engine (originally 20160629104617)
class AddActiveToStallPaymentMethods < ActiveRecord::Migration
  def up
    add_column :stall_payment_methods, :active, :boolean, default: true

    PaymentMethod.update_all(active: true)
  end

  def down
    remove_column :stall_payment_methods, :active
  end
end
