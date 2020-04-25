class RecipesController < ApplicationController
  def new
    @recipe = Recipe.new
    @recipe.ingredients << Ingredient.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to user_path(current_user.id)
    else
      flash.alert = @recipe.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
    @recipe = current_user.recipes.find(params[:id])
  end

  def recipe_params
    params.require(:recipe).permit(
      :instructions,
      :name,
      :notes,
      ingredients_attributes: [
        :id,
        :measurement_unit_id,
        :name,
        :quantity,
        :_destory
      ]
    )
  end
end
