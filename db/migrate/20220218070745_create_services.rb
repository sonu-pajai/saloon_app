class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name
      t.decimal :price
      t.integer :time
      t.references :company

      t.timestamps
    end

    add_index :services, :name, unique: true
  end
end
