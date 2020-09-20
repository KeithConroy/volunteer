class AddRoleIdToShifts < ActiveRecord::Migration[6.0]
  def change
    add_reference :shifts, :role, index: true
  end
end
