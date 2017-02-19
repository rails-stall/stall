# This migration comes from stall_engine (originally 20170125152622)
class ConvertAllMoneyFieldsToDecimalToUseInfinitePrecision < ActiveRecord::Migration
  def up
    change_column :stall_adjustments, :price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_adjustments, :eot_price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_credit_notes, :eot_amount_cents, :decimal, precision: 13, scale: 3
    change_column :stall_credit_notes, :amount_cents, :decimal, precision: 13, scale: 3
    change_column :stall_line_items, :unit_eot_price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_line_items, :unit_price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_line_items, :eot_price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_line_items, :price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_shipments, :price_cents, :decimal, precision: 13, scale: 3
    change_column :stall_shipments, :eot_price_cents, :decimal, precision: 13, scale: 3
  end

  def down
    change_column :stall_adjustments, :price_cents, :integer
    change_column :stall_adjustments, :eot_price_cents, :integer
    change_column :stall_credit_notes, :eot_amount_cents, :integer
    change_column :stall_credit_notes, :amount_cents, :integer
    change_column :stall_line_items, :unit_eot_price_cents, :integer
    change_column :stall_line_items, :unit_price_cents, :integer
    change_column :stall_line_items, :eot_price_cents, :integer
    change_column :stall_line_items, :price_cents, :integer
    change_column :stall_shipments, :price_cents, :integer
    change_column :stall_shipments, :eot_price_cents, :integer
  end
end
