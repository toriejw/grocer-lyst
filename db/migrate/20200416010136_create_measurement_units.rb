class CreateMeasurementUnits < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_units do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :measurement_units, :name, unique: true
  end
end
