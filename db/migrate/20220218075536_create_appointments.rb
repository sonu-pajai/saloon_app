class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :company
      t.references :service
      t.references :user
      t.references :start_time
      t.references :end_time
      t.date       :date
      t.integer    :status, default: 0
      t.timestamps
    end

    add_index :appointments, [:company_id, :status]
    add_index :appointments, [:company_id, :date]
  end
end
