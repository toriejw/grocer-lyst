require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    subject { post :create, params: { user: user_params } }
    let(:user_params) {
      { email: "email@example.com", name: "name", password: "password" }
    }

    it "redirects to the user path" do
      expect(subject).to redirect_to(user_path(User.last))
    end

    it "creates a user" do
      expect { subject }.to change { User.count }.by 1
    end

    context "no email is provided" do
      let(:user_params) {
        { email: nil, name: "name", password: "password" }
      }

      it "renders the sign up form with an error" do
        expect(subject).to render_template(:new)

        expect(flash.alert).to eq "Email can't be blank, Email is invalid"
      end
    end

    context "no password is provided" do
      let(:user_params) {
        { email: "email@example.com", name: "user1234", password: nil }
      }

      it "renders the sign up form with an error" do
        expect(subject).to render_template(:new)

        expect(flash.alert).to eq "Password can't be blank"
      end
    end
  end

end
