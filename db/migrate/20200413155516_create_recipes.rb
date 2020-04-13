class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.text :name, null: false
      t.text :instructions
      t.text :notes

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :recipes, [ :name, :user_id ], unique: true
  end
end
