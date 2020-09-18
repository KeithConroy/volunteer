class CreateActivitySlots < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_slots do |t|
      t.references :activity_instance, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
