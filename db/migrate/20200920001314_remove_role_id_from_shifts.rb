class RemoveRoleIdFromShifts < ActiveRecord::Migration[6.0]
  def change
    remove_reference :shifts, :role, index: true
  end
end
