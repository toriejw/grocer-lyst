require "rails_helper"

feature "Create a new recipe", js: true do
  include Helpers::FeatureAuthentication

  let(:user) { User.create!(username: "user1234", password: "password") }

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

    within all(".field")[0] do
      find("input").set "Chocolate chips"
    end

    click_on "Add ingredient"

    within all(".field")[1] do
      find("input").set "Eggs"
    end

    click_on "Add ingredient"

    within all(".field")[2] do
      find("input").set "Milk"
    end

    within all(".nested-fields")[2] do
      click_on "Remove ingredient"
    end

    expect { click_button "Save recipe" }.to change { Recipe.count }.by 1

    recipe = Recipe.last

    expect(recipe.name).to eq "Chocolate chip cookies"
    expect(recipe.instructions).to eq "Blend all ingredients and bake for 15 minutes"
    expect(recipe.notes).to eq "Grandma's favorite!"
    expect(recipe.ingredients.count).to eq 2
    expect(recipe.ingredients.pluck(:name)).to match_array [ "Chocolate chips", "Eggs"]
  end
end
