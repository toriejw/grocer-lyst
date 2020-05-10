require "rails_helper"

describe SessionsController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    subject { post :create, params: user_params }
    let(:user_params) {
      { email: email, password: password }
    }
    let(:email) { "email@example.com" }
    let(:password) { "password" }

    context "user exists" do
      let!(:user) { User.create!(name: "name", email: email, password: password) }

      context "user credentials are valid" do
        it "logs in the user" do
          expect(subject).to redirect_to(user_path(user))
          expect(session[:user_id]).to eq user.id
        end
      end

      context "user credentials are invalid" do
        let(:user_params) {
          { email: email, password: "badpassword" }
        }

        it "does not log in the user" do
          expect(subject).to redirect_to(login_path)
          expect(session[:user_id]).to eq nil
          expect(flash.alert).to eq "Invalid login credentials"
        end
      end
    end

    context "user does not exist" do
      it "does not log in the user" do
        expect(subject).to redirect_to(login_path)
        expect(session[:user_id]).to eq nil
        expect(flash.alert).to eq "Invalid login credentials"
      end
    end
  end

end
