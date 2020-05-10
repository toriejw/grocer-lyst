require "rails_helper"

describe GroceryListItem do
  let(:grocery_list_item) {
    create(:grocery_list_item, measurement_unit: measurement_unit)
  }
  let(:measurement_unit) { nil }
  let(:ingredient_quantity) { "1 1/2" }

  describe "#add_amount_from" do
    let(:subject) { grocery_list_item.add_amount_from(ingredient) }
    let(:ingredient) {
      create(:ingredient, measurement_unit: ingredient_measurement_unit, quantity: ingredient_quantity)
    }
    let(:ingredient_measurement_unit) { measurement_unit }

    context "ingredient and item have the same measurement_unit" do
      let(:measurement_unit) { create(:measurement_unit) }

      it "combines the quantities" do
        expect(grocery_list_item.amount.to_f).to eq 1.25
        expect(grocery_list_item.amount.measurement_unit).to eq measurement_unit

        subject

        expect(grocery_list_item.amount.to_f).to eq 2.75
        expect(grocery_list_item.amount.measurement_unit).to eq measurement_unit
      end
    end

    context "ingredient and item have differing measurement_units" do
      context "measurement_units can be compared" do
        let(:measurement_unit) { create(:measurement_unit, name: "tablespoon") }
        let(:ingredient_measurement_unit) { create(:measurement_unit, name: "teaspoon") }

        it "combines the quantities and returns a single measurement_unit"
      end

      context "measurement_units cannot be compared" do
        let(:measurement_unit) { create(:measurement_unit) }
        let(:ingredient_measurement_unit) { create(:measurement_unit, name: "incomparable") }

        it "raises an error" do
          expect { subject }.to raise_error(/Cannot convert between/)
        end
      end
    end

    context "neither ingredient nor item have a measurement_unit" do
      let(:ingredient_measurement_unit) { nil }
      let(:ingredient_quantity) { "2.7" }


      it "combines the quantities" do
        expect(grocery_list_item.amount.to_f).to eq 1.25
        expect(grocery_list_item.amount.measurement_unit).to eq nil

        subject

        expect(grocery_list_item.amount.to_f).to eq 3.95
        expect(grocery_list_item.amount.measurement_unit).to eq nil
      end
    end

    context "item quantity was less than 1" do
      let(:grocery_list_item) {
        create(:grocery_list_item, name: "chocolate", quantity: 0.25)
      }

      context "and addition results in quantity greater than 1" do
        let(:ingredient_quantity) { 1 }

        it "pluralizes the item name" do
          subject

          expect(grocery_list_item.amount.to_f).to eq 1.25
          expect(grocery_list_item.name).to eq "chocolates"
        end
      end

      context "and addition results in quantity less than 1" do
        let(:ingredient_quantity) { 0.5 }

        it "does not change the item name" do
          subject

          expect(grocery_list_item.amount.to_f).to eq 0.75
          expect(grocery_list_item.name).to eq "chocolate"
        end
      end

      context "and addition results in quantity equal to 1" do
        let(:ingredient_quantity) { 0.75 }

        it "does not change the item name" do
          subject

          expect(grocery_list_item.amount.to_f).to eq 1
          expect(grocery_list_item.name).to eq "chocolate"
        end
      end
    end
  end
end
