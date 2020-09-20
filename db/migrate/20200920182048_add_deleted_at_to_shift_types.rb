class AddDeletedAtToShiftTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :shift_types, :deleted_at, :datetime
    add_index :shift_types, :deleted_at
  end
end
