class ChangeNullConstraintOnShiftTypes < ActiveRecord::Migration[6.0]
  def change
    change_column_null :shift_types, :role_id, true
  end
end
