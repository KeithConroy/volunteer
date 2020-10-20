class ChangeFrequencyTypeOnSchedules < ActiveRecord::Migration[6.0]
  def up
    change_column :schedules, :frequency, 'integer USING CAST(frequency AS integer)'
  end

  def down
    change_column :schedules, :frequency, :string
  end
end
