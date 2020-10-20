class RenameDatesOnSchedules < ActiveRecord::Migration[6.0]
  def change
    rename_column :schedules, :start_day, :start_date
    rename_column :schedules, :end_day, :end_date
  end
end
