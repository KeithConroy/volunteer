class AddRoleIdToShiftTypes < ActiveRecord::Migration[6.0]
  def change
    add_reference :shift_types, :role, index: true
  end
end
