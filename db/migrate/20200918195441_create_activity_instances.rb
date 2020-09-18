class CreateActivityInstances < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_instances do |t|
      t.references :activity_type, null: true, foreign_key: true
      t.integer :slots
      t.references :address, null: true, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
