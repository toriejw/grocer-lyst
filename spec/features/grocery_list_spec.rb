require "rails_helper"

feature "Grocery list" do
  include Helpers::FeatureAuthentication

  let(:user)     { create(:user) }
  let!(:recipe1) { create(:recipe, user: user) }
  let!(:recipe2) { create(:recipe, user: user) }
  let!(:recipe3) { create(:recipe, user: user) }
  let!(:ingredient1) { create(:ingredient, recipe: recipe1, name: "Zuchinni") }
  let!(:ingredient2) {
    create(:ingredient,
      recipe: recipe1,
      name: "Flour",
      measurement_unit: measurement_unit
    )
  }
  let!(:ingredient3) {
    create(:ingredient,
      recipe: recipe2,
      name: "Flour",
      quantity: "1/2",
      measurement_unit: measurement_unit
    )
  }
  let!(:ingredient4) { create(:ingredient, recipe: recipe2, name: "orange") }
  let!(:ingredient5) { create(:ingredient, recipe: recipe3) }
  let(:measurement_unit) { create(:measurement_unit) }

  before do
    sign_in(user)
  end

  it "allows a user to generate a grocery list" do
    travel_to Time.now do
      visit user_path(user)
      click_on "Create new grocery list"

      check "grocery_list_recipe_ids_#{recipe1.id}"
      check "grocery_list_recipe_ids_#{recipe2.id}"

      click_on "Generate grocery list"

      expect(current_path).to eq user_path(user)
      expect(user.grocery_list).to_not eq nil
      expect(page).to have_text "Generated #{user.grocery_list.created_at}"
      expect(page).to have_text "1.5 cups flour"
      expect(page).to have_text "1 orange"
      expect(page).to have_text "1 zuchinni"
      expect(page).to have_text "Grocery list for recipes: #{recipe1.name}, #{recipe2.name}"

      click_on "Create new grocery list"

      check "grocery_list_recipe_ids_#{recipe3.id}"

      click_on "Generate grocery list"

      expect(page).to have_text "Generated #{user.grocery_list.created_at}"
      expect(page).to have_text "1 #{ingredient5.name.downcase}"
      expect(page).to have_text "Grocery list for recipes: #{recipe3.name}"
    end
  end
end
