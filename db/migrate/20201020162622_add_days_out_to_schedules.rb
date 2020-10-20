class AddDaysOutToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :days_out, :integer
  end
end
