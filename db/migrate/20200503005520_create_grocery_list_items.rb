class CreateGroceryListItems < ActiveRecord::Migration[6.0]
  def change
    create_table :grocery_list_items do |t|
      t.text :name
      t.decimal :quantity
      t.references :grocery_list
      t.references :measurement_unit

      t.timestamps
    end
  end
end
