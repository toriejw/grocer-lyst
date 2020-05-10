require "rails_helper"

describe GroceryListsController do
  include Helpers::ControllerAuthentication

  let(:user) { create(:user) }

  describe "GET #new" do
    let(:subject) { get :new, params: { user_id: user.id } }

    context "user is logged in" do
      before do
        sign_in(user)
      end

      it "returns http succes" do
        subject

        expect(response).to have_http_status(:success)
      end
    end

    context "user is not logged in" do
      it "redirects" do
        expect(subject).to redirect_to(login_path)
      end
    end
  end

  describe "POST #create" do
    let(:subject) {
      post :create, params: { user_id: user.id, grocery_list: { recipe_ids: recipe_ids } }
    }
    let(:recipe_ids) { [ recipe1.id ] }
    let(:recipe1) { create(:recipe, user: user) }
    let(:recipe2) { create(:recipe, user: user) }

    context "user is logged in" do
      before do
        sign_in(user)
      end

      it "returns http success" do
        subject

        expect(response).to have_http_status(:success)
      end

      context "user has no grocery list" do
        let(:recipe_ids) { [ recipe1.id, recipe2.id ] }
        let!(:ingredient1) { create(:ingredient, recipe: recipe1) }
        let!(:ingredient2) { create(:ingredient, recipe: recipe2) }
        let!(:ingredient3) { create(:ingredient, recipe: recipe2) }

        let(:expected_grocery_item_names) {
          [
            ingredient1.name,
            ingredient2.name,
            ingredient3.name
          ]
        }

        it "creates a grocery list" do
          expect(user.grocery_list).to eq nil

          subject

          expect(user.reload.grocery_list).to_not eq nil

          grocery_list_items = user.grocery_list.grocery_list_items

          expect(grocery_list_items.count).to eq 3
          expect(grocery_list_items.pluck(:name)).to eq expected_grocery_item_names
        end
      end

      context "user has an existing grocery list" do
        let(:recipe_ids) { [ recipe1.id, recipe2.id ] }

        before do
          create(:grocery_list, user: user)
        end

        it "replaces the existing grocery list"
      end

      context "no recipes are provided" do
        it "does not create a new list" do
          expect(user.grocery_list).to eq nil

          subject

          expect(user.reload.grocery_list).to eq nil
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
