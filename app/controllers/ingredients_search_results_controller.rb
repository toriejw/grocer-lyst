class IngredientsSearchResultsController < ApplicationController

  def index
    render json: { results: IngredientSearch.new(params[:query]).results(1) }
  end

end
