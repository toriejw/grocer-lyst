class GroceryListsController < ApplicationController
  def new
    @grocery_list = GroceryList.new
  end

  def create
    if GroceryListGenerator.new(current_user, recipe_ids).generate
      redirect_to user_path(current_user)
    else
      flash.alert = "There was an issue creating your grocery list. Please try again."
      render :new
    end
  end

  def recipe_ids
    grocery_list_params[:recipe_ids]
  end

  def grocery_list_params
    params.require(:grocery_list).permit(recipe_ids: [])
  end
end
