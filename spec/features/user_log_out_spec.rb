require "rails_helper"

feature "User log out" do
  include Helpers::Authentication

  context "user is logged in" do
    let(:user) { User.create!(username: "user1234", password: "password") }

    before do
      sign_in(user)
    end

    it "allows the user to log out" do
      visit user_path(user)

      expect(current_path).to eq user_path(user)

      click_button("Log Out")

      expect(current_path).to eq root_path

      visit user_path(user)

      expect(current_path).to eq login_path
    end
  end

  context "user is not logged in" do
    it "does not show the log out button" do
      visit root_path

      expect(page).to_not have_text "Log Out"
    end
  end
end
