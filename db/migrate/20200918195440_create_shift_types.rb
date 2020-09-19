class CreateShiftTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :shift_types do |t|
      t.references :organization, null: true, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
