class IngredientsController < ApplicationController

  skip_before_action :authorize!

  def create
    ingredient = Ingredient.create!(ingredient_params)
    redirect_to new_ingredient_path, notice: "#{ingredient.name.capitalize} added successfully!"
  end

  def new
  end

  private

    def ingredient_params
      params.require(:ingredient).permit(:name)
    end

end
