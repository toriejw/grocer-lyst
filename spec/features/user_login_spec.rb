require "rails_helper"

feature "User login" do
  let(:email) { "email@example.com" }
  let(:password) { "password" }

  context "user provides valid login credentials" do
    let!(:user) { create(:user, email: email, password: password) }

    it "redirects to the user's profile page" do
      visit login_path

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log In"

      expect(current_path).to eq user_path(user)
    end
  end

  context "user provides invalid login credentials" do
    it "notifies the user" do
      visit login_path

      fill_in :email, with: email
      fill_in :password, with: password

      click_button "Log In"

      expect(current_path).to eq login_path
      expect(page).to have_text("Invalid login credentials")
    end
  end
end
