class CreateStallUserOmniauthAccounts < ActiveRecord::Migration
  def change
    create_table :stall_user_omniauth_accounts do |t|
      t.references :user, index: true
      t.string :provider
      t.string :uid
      t.jsonb :scopes

      t.timestamps null: false
    end

    add_foreign_key :stall_user_omniauth_accounts, :stall_users, column: 'user_id'
  end
end
