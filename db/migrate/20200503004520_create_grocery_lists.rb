class CreateGroceryLists < ActiveRecord::Migration[6.0]
  def change
    create_table :grocery_lists do |t|
      t.references :user, null: false
      t.text :recipe_ids, array: true

      t.timestamps
    end
  end
end
