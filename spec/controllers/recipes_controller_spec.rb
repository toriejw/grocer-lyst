require "rails_helper"

describe RecipesController do
  include Helpers::ControllerAuthentication

  let(:user) { User.create!(name: "name", email: "email@example.com", password: "password") }

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
              "0" => { name: "Chocolate chips", quantity: "1.5", _destroy: false },
              "123456" => {
                name: "Flour",
                quantity: "2 1/2",
                measurement_unit_id: measurement_unit.id,
                _destroy: false,
              },
              "1586832043118" => { name: "Eggs", _destroy: false }
            }
          }
        }
        let(:measurement_unit) { create(:measurement_unit) }

        it "creates a recipe" do
          expect { subject }.to change { user.recipes.count }.by 1

          recipe = user.recipes.last

          expect(recipe.name).to eq "Cookies"
          expect(recipe.instructions).to eq "Mix!\nBake!\nEnjoy!"
          expect(recipe.ingredients.count).to eq 3

          flour = recipe.ingredients.find_by_name("Flour")

          expect(flour.quantity).to eq "2 1/2"
          expect(flour.measurement_unit).to eq measurement_unit
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

  describe "DELETE #destroy" do
    let(:subject) { delete :destroy, params: { user_id: user.id, id: recipe.id } }
    let!(:recipe) { create(:recipe, user: user) }
    let!(:ingredient) { create(:ingredient, recipe: recipe) }

    context "user is logged in" do
      before do
        sign_in(user)
      end

      it "deletes the recipe and ingredients" do
        expect { subject }.to change { user.recipes.count }.by -1
        expect { recipe.reload }.to raise_error(ActiveRecord::RecordNotFound)
        expect { ingredient.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "redirects to the user's page on success" do
        expect(subject).to redirect_to(user_path(user))
      end

      context "recipe ID is for a different user" do
        let!(:recipe) { create(:recipe, user: create(:user)) }

        it "raises an error" do
          expect {
            subject
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    context "user is not logged in" do
      it "does not delete the recipe" do
        expect(subject).to redirect_to(login_path)
      end
    end
  end
end
