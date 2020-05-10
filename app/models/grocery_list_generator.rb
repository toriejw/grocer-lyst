class GroceryListGenerator
  def initialize(user, recipe_ids = [])
    @user = user
    @recipe_ids = recipe_ids
  end

  def generate
    return if recipes.empty? || all_recipe_ingredients.empty?

    grocery_list = GroceryList.create!(user: @user)
    grocery_list.add_ingredients(all_recipe_ingredients)

    grocery_list.recipe_ids = @recipes.map(&:id)
    grocery_list.save!
  end

  private

    def all_recipe_ingredients
      recipes.map { |recipe| recipe.ingredients }.flatten
    end

    def recipes
      @recipes ||= @user.recipes.find(@recipe_ids)
    end
end
