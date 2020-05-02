require "rails_helper"

feature "Editing a recipe", js: true do
  include Helpers::FeatureAuthentication
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }
  let!(:ingredient) { create(:ingredient, recipe: recipe) }
  let!(:measurement_unit) { create(:measurement_unit) }

  before do
    sign_in(user)
  end

  it "allows the user to edit a recipe" do
    visit user_recipe_path(user, recipe)

    expect(page).to have_text recipe.name
    expect(page).to have_text "Ingredients"
    expect(page).to have_text ingredient.name.downcase
    expect(page).to have_text ingredient.amount

    click_button "Edit recipe"

    expect(current_path).to eq edit_user_recipe_path(user, recipe)

    fill_in :recipe_name, with: "Cookies!!"
    fill_in :recipe_instructions, with: "Bake and enjoy"
    fill_in :recipe_notes, with: "Sarah's favorites"

    within all(".nested-fields")[0] do
      all("input")[0].set "secret ingredient"
      all("input")[1].set "1/3"
      find(:select).find(:option, :cup).select_option
    end

    click_link "Add ingredient"

    within all(".nested-fields")[recipe.ingredients.count] do
      all("input")[0].set "additional secret ingredient"
      all("input")[1].set "2"
      find(:select).find(:option, :cup).select_option
    end

    expect { click_button "Save" }.to change { recipe.ingredients.count }.by 1

    expect(current_path).to eq user_recipe_path(user, recipe)

    expect(page).to have_text "Cookies!!"
    expect(page).to have_text "Bake and enjoy"
    expect(page).to have_text "Sarah's favorites"

    expect(page).to have_text "secret ingredient"
    expect(page).to have_text "1/3 cup"

    expect(page).to have_text "additional secret ingredient"
    expect(page).to have_text "2 cups"
  end

  it "allows the user to remove an ingredient from a recipe"
end
