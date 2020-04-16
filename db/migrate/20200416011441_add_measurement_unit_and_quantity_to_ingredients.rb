class AddMeasurementUnitAndQuantityToIngredients < ActiveRecord::Migration[6.0]
  def change
    add_column :ingredients, :quantity, :text, null: false, default: "1"
    add_reference :ingredients, :measurement_unit, foreign_key: true
  end
end
