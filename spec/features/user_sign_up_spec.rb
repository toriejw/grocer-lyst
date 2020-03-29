require "rails_helper"

feature "User sign up" do
  let(:username) { "user1234" }

  def click_submit
    click_button "Create account"
  end

  it "allows a user to sign up" do
    visit new_user_path

    expect(page).to have_text "Create an account"

    fill_in "user_username", with: username
    fill_in "user_password", with: "securepassword"

    expect { click_submit }.to change { User.count }.by 1

    new_user = User.last

    expect(new_user.username).to eq username
    expect(new_user.password_digest).to_not be nil
    expect(current_path).to eq user_path(new_user)
  end

  context "no password is provided" do
    it "does not allow the user to submit the form" do
      visit new_user_path

      fill_in "user_username", with: username
      click_submit

      expect(page).to have_text "Password can't be blank"
    end
  end

  context "no username is provided" do
    it "does not allow the user to submit the form" do
      visit new_user_path

      fill_in "user_password", with: "password"
      click_submit

      expect(page).to have_text "Username can't be blank"
    end
  end

  context "username has already been taken" do
    before do
      User.create!(username: username, password: "password")
    end

    it "prompts the user to choose another username" do
      visit new_user_path

      fill_in "user_username", with: username
      fill_in "user_password", with: "securepassword"

      click_submit

      expect(page).to have_text "Username \"#{username}\" is already taken. Please choose another!"
    end
  end
end
