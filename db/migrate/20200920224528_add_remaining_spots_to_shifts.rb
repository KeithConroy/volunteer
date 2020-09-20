class AddRemainingSpotsToShifts < ActiveRecord::Migration[6.0]
  def change
    add_column :shifts, :remaining_spots, :integer
  end
end
