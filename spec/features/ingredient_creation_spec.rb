require "rails_helper"

feature "Create a new ingredient" do
  it "allows a user to create an ingredient" do
    visit new_ingredient_path

    expect(page).to have_text("Add an ingredient:")

    fill_in "ingredient_name", with: "Zuchinni"

    expect {
      click_button "Create"
    }.to change { Ingredient.count }.by 1

    expect(current_path).to eq new_ingredient_path
    expect(page).to have_text("added successfully!")
  end
end
