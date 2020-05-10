require 'rails_helper'

describe GroceryList do
  let(:grocery_list) { create(:grocery_list) }

  describe "#add_ingredients" do
    let(:subject)     { grocery_list.add_ingredients(ingredients) }
    let(:ingredients) { [] }

    let(:ingredient1) { create(:ingredient) }
    let(:ingredient2) { create(:ingredient, measurement_unit: cup_measurement_unit) }
    let(:ingredient3) { create(:ingredient, quantity: "2 1/2") }
    let(:ingredient4) { create(:ingredient) }
    let(:cup_measurement_unit) { create(:measurement_unit) }
    let(:tablespoon_measurement_unit) { create(:measurement_unit, name: "tablespoon") }

    context "grocery_list has no items" do
      let(:ingredients) { [ ingredient1, ingredient2 ] }

      it "adds the ingredients to the list" do
        expect { subject }.to change { grocery_list.grocery_list_items.count }.by 2

        ingredients.each do |ingredient|
          item = grocery_list.grocery_list_items.find { |item| item.name == ingredient.name }

          expect(item.quantity).to eq 1.0
          expect(item.measurement_unit).to eq ingredient.measurement_unit
        end
      end
    end

    context "grocery_list has existing items" do
      let(:existing_ingredients) { [ ingredient1, ingredient2 ] }

      before do
        grocery_list.add_ingredients(existing_ingredients)
      end

      context "new ingredients are different from existing items" do
        let(:ingredients) { [ ingredient3, ingredient4 ] }

        it "adds the new ingredients to the list" do
          expect { subject }.to change { grocery_list.grocery_list_items.count }.by 2

          expect(grocery_list.grocery_list_items.count)

          (ingredients + existing_ingredients).each do |ingredient|
            item = grocery_list.grocery_list_items.find { |item| item.name == ingredient.name }

            expect(item.quantity).to eq ingredient.amount.rationalized_quantity.to_f
            expect(item.measurement_unit).to eq ingredient.measurement_unit
          end
        end
      end

      context "new ingredients include items already on the list" do
        let(:ingredients) { [ duplicate_ingredient ] }

        context "with the same measurement type" do
          let(:duplicate_ingredient) {
            create(:ingredient,
              name: ingredient2.name,
              quantity: "1 1/4",
              measurement_unit: cup_measurement_unit
            )
          }

          it "combines the new ingredient with the existing grocery list item"
        end

        context "with differing measurement types" do
          let(:duplicate_ingredient) {
            create(:ingredient,
              name: ingredient2.name,
              quantity: "1 1/4",
              measurement_unit: tablespoon_measurement_unit
            )
          }

          context "and measurement types can be combined" do
            it "combines the new ingredient with the existing grocery list item"
          end

          context "and measurement types cannot be combined" do
            it "creates a new grocery_list_item"
          end

          context "multiple items with differing measurement types exist" do
            it "adds it to one of the items with a comparable measurement unit"
          end
        end

        context "neither ingredient has a measurement type" do
          let(:duplicate_ingredient) {
            create(:ingredient, name: ingredient1.name, quantity: "1/8" )
          }

          it "combines the new ingredient with the existing grocery list item" do
            item = grocery_list.grocery_list_items.find { |item| item.name == duplicate_ingredient.name }
            expect(item.quantity).to eq 1.0

            expect { subject }.to_not change { grocery_list.grocery_list_items.count}

            expect(item.quantity).to eq 1.125
          end
        end
      end
    end

    context "ingredients to add include ingredients with the same name" do
      context "with the same measurement type" do
      end

      context "with no measurement type" do
      end

      context "with differing measurement types" do
      end
    end
  end
end
