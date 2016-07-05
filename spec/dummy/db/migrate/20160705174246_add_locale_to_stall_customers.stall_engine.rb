# This migration comes from stall_engine (originally 20160705110151)
class AddLocaleToStallCustomers < ActiveRecord::Migration
  def change
    add_column :stall_customers, :locale, :string, default: I18n.default_locale
  end
end
