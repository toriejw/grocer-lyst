require "rails_helper"

describe IngredientsController do
  describe "#create" do
    let(:subject) { post :create, params: params }
    let(:params) {
      { ingredient: { name: name } }
    }
    let(:name) { "black beans" }

    it "creates a new ingredient record" do
      expect { subject }.to change { Ingredient.count }.by 1
      expect(Ingredient.last.name).to eq name
    end

    it "redirects to the new ingredient page" do
      expect(subject).to redirect_to(new_ingredient_url)
    end

    it "notifies the user that the ingredient was added" do
      subject

      expect(flash[:notice]).to match("#{name.capitalize} added successfully!")
    end

    context "request is missing params" do
      let(:params) {
        { ingredient: {} }
      }

      it "returns 5xx" do
        expect {
          subject
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end
end
