require "rails_helper"

describe RecipesController do
  include Helpers::ControllerAuthentication

  let(:user) { User.create!(username: "user1234", password: "password") }

  describe "GET #new" do
    before do
      sign_in(user)
    end

    it "returns http success" do
      get :new, params: { user_id: user.id }

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:subject) {
      post :create, params: { user_id: user.id, recipe: recipe_params }
    }
    let(:recipe_params) {
      {
        name: "Cookies",
        instructions: "Mix!\nBake!\nEnjoy!",
        notes: "Best eaten dipped in hot chocolate"
      }
    }

    context "user is logged in" do
      before do
        sign_in(user)
      end

      it "redirects to the user's page on success" do
        expect(subject).to redirect_to(user_path(user))
      end

      context "with ingredients" do
        let(:recipe_params) {
          {
            name: "Cookies",
            instructions: "Mix!\nBake!\nEnjoy!",
            ingredients_attributes: {
              "0" => { name: "Chocolate chips", _destroy: false },
              "123456" => { name: "Flour", _destroy: false, },
              "1586832043118" => { name: "Eggs", _destroy: false }
            }
          }
        }

        it "creates a recipe" do
          expect { subject }.to change { user.recipes.count }.by 1

          recipe = user.recipes.last

          expect(recipe.name).to eq "Cookies"
          expect(recipe.instructions).to eq "Mix!\nBake!\nEnjoy!"
          expect(recipe.ingredients.count).to eq 3
        end
      end

      context "with no ingredients" do
        it "creates a recipe" do
          expect { subject }.to change { user.recipes.count }.by 1

          recipe = user.recipes.last

          expect(recipe.name).to eq "Cookies"
          expect(recipe.instructions).to eq "Mix!\nBake!\nEnjoy!"
          expect(recipe.notes).to eq "Best eaten dipped in hot chocolate"
          expect(recipe.ingredients.count).to eq 0
        end
      end

      context "with multiple ingredients with the same name" do
        # we allow this case for situations where a recipe requires different
        # measurement units for the same ingredient (eg. 1/4 cup + 2 tsps of olive oil)
        let(:recipe_params) {
          {
            name: "Cookies",
            instructions: "Mix!\nBake!\nEnjoy!",
            ingredients_attributes: {
              "0" => { name: "Flour", _destroy: false },
              "123456" => { name: "Flour", _destroy: false, }
            }
          }
        }

        it "creates a recipe" do
          expect { subject }.to change { user.recipes.count }.by 1

          recipe = user.recipes.last

          expect(recipe.name).to eq "Cookies"
          expect(recipe.instructions).to eq "Mix!\nBake!\nEnjoy!"
          expect(recipe.notes).to eq nil
          expect(recipe.ingredients.count).to eq 2
        end
      end

      describe "invalid data" do
        let(:recipe_params) {
          { instructions: "Enjoy!" }
        }

        context "name is missing" do
          it "renders the form with an error" do
            expect(subject).to render_template(:new)

            expect(flash.alert).to eq "Name can't be blank"
          end
        end
      end
    end

    context "user is not logged in" do
      it "redirects" do
        expect(subject).to redirect_to(login_path)
      end
    end
  end
end
