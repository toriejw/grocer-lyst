require "rails_helper"

feature "Create a new recipe", js: true do
  include Helpers::FeatureAuthentication

  let(:user) { create(:user) }
  let!(:measurement_unit) { create(:measurement_unit) }

  before do
    sign_in(user)
  end

  it "allows a user to create a recipe" do
    visit user_path(user)

    click_button "Add a recipe"

    expect(current_path).to eq new_user_recipe_path(user)

    fill_in :recipe_name, with: "Chocolate chip cookies"
    fill_in :recipe_instructions, with: "Blend all ingredients and bake for 15 minutes"
    fill_in :recipe_notes, with: "Grandma's favorite!"

    within all(".nested-fields")[0] do
      all("input")[0].set "Chocolate chips"
      all("input")[1].set "1/3"
      find(:select).find(:option, :cup).select_option
    end

    click_on "Add ingredient"

    within all(".nested-fields")[1] do
      all("input")[0].set "Eggs"
      all("input")[1].set "2"
    end

    click_on "Add ingredient"

    within all(".nested-fields")[2] do
      all("input")[0].set "Milk"
      click_on "Remove ingredient"
    end

    expect { click_button "Save recipe" }.to change { Recipe.count }.by 1

    recipe = Recipe.last

    expect(recipe.name).to eq "Chocolate chip cookies"
    expect(recipe.instructions).to eq "Blend all ingredients and bake for 15 minutes"
    expect(recipe.notes).to eq "Grandma's favorite!"
    expect(recipe.ingredients.count).to eq 2
    expect(recipe.ingredients.pluck(:name)).to match_array [ "Chocolate chips", "Eggs"]

    chocolate_chips = recipe.ingredients.find_by_name("Chocolate chips")

    expect(chocolate_chips.quantity).to eq "1/3"
    expect(chocolate_chips.measurement_unit).to eq measurement_unit
  end
end
