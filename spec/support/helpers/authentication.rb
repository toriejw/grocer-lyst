module Helpers
  module FeatureAuthentication
    def sign_in(user)
      visit login_path

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_button "Log In"
    end
  end

  module ControllerAuthentication
    def sign_in(user)
      session[:user_id] = user.id
    end
  end
end
