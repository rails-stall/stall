class CreateCreditNoteAdjustments < ActiveRecord::Migration
  def change
    create_table :stall_credit_note_usages do |t|
      t.references :credit_note, index: true
      t.references :adjustment, index: true

      t.timestamps null: false
    end

    add_foreign_key :stall_credit_note_usages, :stall_credit_notes, column: :credit_note_id
    add_foreign_key :stall_credit_note_usages, :stall_adjustments, column: :adjustment_id
  end
end
