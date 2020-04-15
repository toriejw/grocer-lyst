class AddRecipeIdToIngredients < ActiveRecord::Migration[6.0]
  def change
    add_reference :ingredients, :recipe, foreign_key: true, null: false
  end
end
