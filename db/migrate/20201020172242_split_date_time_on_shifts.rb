class SplitDateTimeOnShifts < ActiveRecord::Migration[6.0]
  def change
    remove_column :shifts, :starts_at, :datetime
    remove_column :shifts, :ends_at, :datetime

    add_column :shifts, :start_time, :time
    add_column :shifts, :end_time, :time
    add_column :shifts, :date, :date
  end
end
