class AddOrganizationToShifts < ActiveRecord::Migration[6.0]
  def change
    add_reference :shifts, :organization, index: true
  end
end
