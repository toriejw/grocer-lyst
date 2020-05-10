require "rails_helper"

feature "Deleting a recipe" do
  include Helpers::FeatureAuthentication

  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, user: user) }

  before do
    sign_in(user)
  end

  it "allows the user to delete a recipe", js: true do
    recipe_name = recipe.name

    visit user_recipe_path(user, recipe)

    expect(page).to have_text recipe_name

    accept_alert "Are you sure you want to delete this recipe?" do
      click_on "Delete recipe"
    end

    expect(current_path).to eq user_path(user)
    expect(page).to_not have_text recipe_name

    expect { recipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
