class CreateTimeSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :time_slots do |t|
      t.string :from_time, index: true, unique: true
      t.string :to_time, index: true, unique: true
      t.timestamps
    end
    add_index :time_slots, [:from_time, :to_time], unique: true

  end
end
