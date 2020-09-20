class RenameSlotsOnShifts < ActiveRecord::Migration[6.0]
  def change
    rename_column :shifts, :slots, :spots
  end
end
