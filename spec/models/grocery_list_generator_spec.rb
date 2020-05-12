require "rails_helper"

describe GroceryListGenerator do
  let(:subject)    { described_class.new(user, recipe_ids) }
  let(:user)       { create(:user) }
  let(:recipe_ids) { [] }

  let(:recipe1) { create(:recipe, user: user) }
  let(:recipe2) { create(:recipe, user: user) }
  let(:recipe3) { create(:recipe, user: user) }

  let(:ingredient1) { create(:ingredient, recipe: recipe1) }
  let(:ingredient2) { create(:ingredient, recipe: recipe1) }
  let(:ingredient3) { create(:ingredient, recipe: recipe1) }
  let(:ingredient4) { create(:ingredient, recipe: recipe2) }
  let(:ingredient5) { create(:ingredient, recipe: recipe2) }
  let(:ingredient6) { create(:ingredient, recipe: recipe3) }

  context "no recipe IDs are provided" do
    it "does not create a grocery_list" do
      expect(user.grocery_list).to eq nil

      subject.generate

      expect(user.grocery_list).to eq nil
    end
  end

  context "one recipe ID is provided" do
    let(:recipe_ids) { [ recipe1.id ] }

    context "recipe has no ingredients" do
      it "does not create a grocery_list" do
        expect(user.grocery_list).to eq nil

        subject.generate

        expect(user.grocery_list).to eq nil
      end
    end

    context "recipe has ingredients" do
      let!(:ingredients) { [ ingredient1, ingredient2, ingredient3 ] }

      it "creates a grocery list" do
        expect(user.grocery_list).to eq nil

        subject.generate

        expect(user.grocery_list).to_not eq nil

        grocery_list_items = user.grocery_list.grocery_list_items

        ingredients.each do |ingredient|
          item = grocery_list_items.find { |item| item.name == ingredient.name }

          expect(item).to_not eq nil
          expect(item.quantity).to eq ingredient.quantity.to_f
          expect(item.measurement_unit).to eq ingredient.measurement_unit
        end
      end

      it "saves the recipe IDs on the grocery list" do
        subject.generate

        expect(user.grocery_list.recipe_ids).to eq recipe_ids.map(&:to_s)
      end
    end
  end

  context "multiple recipe IDs are provided" do
    let(:recipe_ids) { [ recipe1.id, recipe2.id, recipe3.id ] }
    let!(:ingredients) {
      [
        ingredient1, ingredient2, ingredient3, ingredient4, ingredient5, ingredient6
      ]
    }

    it "generates a grocery list from the combined recipe ingredient lists" do
      subject.generate

      expect(user.grocery_list).to_not eq nil

      grocery_list_items = user.grocery_list.grocery_list_items

      ingredients.each do |ingredient|
        item = grocery_list_items.find { |item| item.name == ingredient.name }

        expect(item).to_not eq nil
        expect(item.quantity).to eq ingredient.quantity.to_f
        expect(item.measurement_unit).to eq ingredient.measurement_unit
      end
    end

    it "saves the recipe IDs on the grocery list" do
      subject.generate

      expect(user.grocery_list.recipe_ids).to eq recipe_ids.map(&:to_s)
    end

    context "recipes have overlapping ingredients" do
      context "and the ingredient measurement units are the same" do
        let(:ingredient1) { create(:ingredient, name: "cookie", recipe: recipe1, quantity: "0.5") }
        let(:ingredient2) { create(:ingredient, name: "chickpea", recipe: recipe1, quantity: "1/4") }
        let(:ingredient3) { create(:ingredient, name: "cookies", recipe: recipe2, quantity: 12) }
        let(:ingredient4) { create(:ingredient, name: "chickpeas", recipe: recipe2, quantity: "2 3/4") }
        let(:ingredient5) { create(:ingredient, name: "cookies", recipe: recipe3, quantity: 12) }
        let(:ingredient6) { create(:ingredient, name: "chickpeas", recipe: recipe3, quantity: 1) }
        let!(:ingredients) {
          [ ingredient1, ingredient2, ingredient3, ingredient4, ingredient5, ingredient6 ]
        }
        let(:recipe_ids) { [ recipe1.id, recipe2.id, recipe3.id ] }

        it "combines the ingredient quantities" do
          subject.generate

          grocery_list_items = user.grocery_list.grocery_list_items

          expect(grocery_list_items.count).to eq 2

          cookies = grocery_list_items.find { |item| item.name == "cookies" }
          chickpeas = grocery_list_items.find { |item| item.name == "chickpeas" }

          expect(cookies).to_not eq nil
          expect(cookies.quantity).to eq 24.5
          expect(cookies.measurement_unit).to eq ingredient1.measurement_unit

          expect(chickpeas).to_not eq nil
          expect(chickpeas.quantity).to eq 4
          expect(chickpeas.measurement_unit).to eq ingredient1.measurement_unit
        end
      end

      context "and the ingredient measurement units are different" do
        let(:teaspoon_measurement_unit) { create(:measurement_unit, name: "teaspoon") }
        let(:tablespoon_measurement_unit) { create(:measurement_unit, name: "tablespoon") }

        let(:ingredient1) {
          create(:ingredient, name: "parsley", recipe: recipe1, measurement_unit: tablespoon_measurement_unit)
        }
        let(:ingredient2) { create(:ingredient, name: "banana", recipe: recipe1) }
        let(:ingredient3) {
          create(:ingredient, name: "parsley", recipe: recipe2, measurement_unit: teaspoon_measurement_unit)
        }
        let!(:ingredients) { [ ingredient1, ingredient2, ingredient3 ] }
        let(:recipe_ids) { [ recipe1.id, recipe2.id ] }

        context "measurement unit combination is possible" do
          it "combines the ingredient quantities" do
            subject.generate

            grocery_list_items = user.grocery_list.grocery_list_items

            expect(grocery_list_items.count).to eq 2

            parsley_items = grocery_list_items.select { |item| item.name.singularize == "parsley" }

            expect(parsley_items.count).to eq 1
            expect(parsley_items.first.quantity.to_f).to eq 1.33
          end
        end

        context "measurement unit combination isn't possible" do
          let(:ingredient1) { create(:ingredient, name: "parsley", recipe: recipe1) }

          it "creates two different grocery list items for the conflicting units" do
            subject.generate

            grocery_list_items = user.grocery_list.grocery_list_items

            expect(grocery_list_items.count).to eq 3

            parsley_items = grocery_list_items.select { |item| item.name == "parsley" }

            expect(parsley_items.count).to eq 2
          end
        end
      end

      context "and the combined quantity is greater than 1" do
        let(:ingredient1) { create(:ingredient, name: "cookie", recipe: recipe1, quantity: "1/2") }
        let(:ingredient2) { create(:ingredient, name: "chickpea", recipe: recipe1, quantity: "1") }
        let(:ingredient3) { create(:ingredient, name: "cookie", recipe: recipe2, quantity: 0.75) }
        let(:ingredient4) { create(:ingredient, name: "chickpeas", recipe: recipe2, quantity: 1.1) }
        let!(:ingredients) {
          [ ingredient1, ingredient2, ingredient3, ingredient4 ]
        }
        let(:recipe_ids) { [ recipe1.id, recipe2.id ] }

        it "pluralizes the grocery list item name" do
          subject.generate

          expect(user.grocery_list.grocery_list_items.count).to eq 2

          grocery_list_item_names = user.grocery_list.grocery_list_items.map(&:name)

          expect(grocery_list_item_names).to include "cookies"
          expect(grocery_list_item_names).to include "chickpeas"
        end
      end
    end
  end

  context "recipe IDs for another user are provided" do
    let(:other_user) { create(:user) }
    let(:recipe_for_other) { create(:recipe, user: other_user) }
    let(:recipe_ids) { [ recipe1.id, recipe_for_other.id ] }

    it "raises an error" do
      expect {
        subject.generate
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
