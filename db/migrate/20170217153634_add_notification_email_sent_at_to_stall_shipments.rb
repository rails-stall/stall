class AddNotificationEmailSentAtToStallShipments < ActiveRecord::Migration
  def change
    add_column :stall_shipments, :notification_email_sent_at, :datetime
  end
end
