class AddScheduleIdToShifts < ActiveRecord::Migration[6.0]
  def change
    add_reference :shifts, :schedule, index: true
  end
end
