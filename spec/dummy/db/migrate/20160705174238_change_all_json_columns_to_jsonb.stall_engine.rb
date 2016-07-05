# This migration comes from stall_engine (originally 20160304134849)
# This allows to avoid SELECT DISTINCT errors where JSON field type would throw
# a PG::UndefinedFunction error
#
# See : https://github.com/activerecord-hackery/ransack/issues/453
#
class ChangeAllJsonColumnsToJsonb < ActiveRecord::Migration
  def up
    change_column :stall_line_items, :data, 'jsonb USING CAST(data AS jsonb)'
    change_column :stall_payments, :data, 'jsonb USING CAST(data AS jsonb)'
    change_column :stall_product_lists, :data, 'jsonb USING CAST(data AS jsonb)'
  end

  def down
    change_column :stall_line_items, :data, 'json USING CAST(data AS json)'
    change_column :stall_payments, :data, 'json USING CAST(data AS json)'
    change_column :stall_product_lists, :data, 'json USING CAST(data AS json)'
  end
end
