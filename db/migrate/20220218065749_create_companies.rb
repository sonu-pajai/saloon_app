class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.references :start_time
      t.references :end_time
      t.string :gstin
      t.string :pan
      t.string :name
      t.text :address
      t.integer :chairs

      t.timestamps
    end
  end
end