require "rails_helper"

feature "User sign up" do
  let(:email) { "email@example.com" }
  let(:name)  { "name" }

  def click_submit
    click_button "Create account"
  end

  it "allows a user to sign up" do
    visit new_user_path

    expect(page).to have_text "Create an account"

    fill_in "user_name", with: name
    fill_in "user_email", with: email
    fill_in "user_password", with: "securepassword"

    expect { click_submit }.to change { User.count }.by 1

    new_user = User.last

    expect(new_user.name).to eq name
    expect(new_user.email).to eq email
    expect(new_user.password_digest).to_not be nil
    expect(current_path).to eq user_path(new_user)
  end

  context "no password is provided" do
    it "does not allow the user to submit the form" do
      visit new_user_path

      fill_in "user_email", with: email
      fill_in "user_name", with: name
      click_submit

      expect(page).to have_text "Password can't be blank"
    end
  end

  context "no email is provided" do
    it "does not allow the user to submit the form" do
      visit new_user_path

      fill_in "user_name", with: name
      fill_in "user_password", with: "password"
      click_submit

      expect(page).to have_text "Email can't be blank"
    end
  end

  context "email has already been taken" do
    before do
      create(:user, email: email)
    end

    it "prompts the user to choose another email" do
      visit new_user_path

      fill_in "user_name", with: name
      fill_in "user_email", with: email
      fill_in "user_password", with: "securepassword"

      click_submit

      expect(page).to have_text "An account with that email has already been created."
    end
  end
end
