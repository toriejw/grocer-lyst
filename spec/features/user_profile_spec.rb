require "rails_helper"

feature "User profile" do
  include Helpers::FeatureAuthentication

  context "user is logged in" do
    let(:user) { User.create!(username: "user1234", password: "password") }
    let!(:recipe1) {
      create(:recipe, user: user, instructions: "Mix & bake :)", notes: "notes on this recipe")
    }
    let!(:recipe2) {
      create(:recipe, user: user, instructions: "Mix & bake :)")
    }

    before do
      sign_in(user)
    end

    it "shows the user's profile" do
      expect(current_path).to eq user_path(user)
      expect(page).to have_text "Welcome, #{user.username}!"

      expect(page).to have_text "Recipes"
      expect(page).to have_link recipe1.name
      expect(page).to have_link recipe2.name

      click_link(recipe1.name)

      expect(current_path).to eq user_recipe_path(user, recipe1)
    end

    it "does not allow the user to visit other profiles" do
      visit user_path(user.id + 1)

      expect(current_path).to eq login_path
    end
  end

  context "user is not logged in" do
    it "redirects to the login page" do
      visit user_path(12)

      expect(current_path).to eq login_path
    end
  end
end
