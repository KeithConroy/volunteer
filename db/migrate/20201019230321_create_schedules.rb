class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.references :shift_type, null: true, foreign_key: true
      t.integer :spots
      t.date :start_day
      t.date :end_day
      t.time :start_time
      t.time :end_time
      t.references :organization, null: true, foreign_key: true
      t.string :frequency
      t.string :frequency_data

      t.timestamps
    end
  end
end
