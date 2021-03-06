require "rails_helper"

describe Ingredient, type: :model do
  describe "validations" do
    describe "quantity field" do
      let(:recipe) { build(:recipe) }
      let(:invalid_format_error) { "Quantity format is invalid" }

      def expect_quantity_to_fail_validation(quantity)
        ingredient = build(:ingredient, quantity: quantity, recipe: recipe)
        ingredient.validate

        expect(ingredient.errors.full_messages).to eq [ invalid_format_error ]
      end

      def expect_quantity_to_pass_validation(quantity)
        ingredient = build(:ingredient, quantity: quantity, recipe: recipe)
        ingredient.validate

        expect(ingredient.errors).to be_empty
      end

      context "invalid input" do
        context "input contains letters" do
          it "fails validation" do
            expect_quantity_to_fail_validation("a")
            expect_quantity_to_fail_validation("three")
            expect_quantity_to_fail_validation("l/l")
          end
        end

        context "input contains invalid special chars" do
          it "fails validation" do
            expect_quantity_to_fail_validation("1*")
            expect_quantity_to_fail_validation("1+2")
          end
        end

        context "input containts valid special chars in invalid locations" do
          it "fails validation" do
            expect_quantity_to_fail_validation("0.")
            expect_quantity_to_fail_validation("1..2")
            expect_quantity_to_fail_validation("0-")
            expect_quantity_to_fail_validation("1 - ")
            expect_quantity_to_fail_validation("-1 - 2")
            expect_quantity_to_fail_validation("1/")
            expect_quantity_to_fail_validation("/2")
            expect_quantity_to_fail_validation("1 2/")
            expect_quantity_to_fail_validation("1./2")
            expect_quantity_to_fail_validation("1 0.5")
            expect_quantity_to_fail_validation("1 1")
            expect_quantity_to_fail_validation("1/2 1/2")
          end
        end

        context "input contains whitesapce in invalid locations" do
          it "fails validation" do
            expect_quantity_to_fail_validation("1 /2")
            expect_quantity_to_fail_validation("1 1 1/2")
            expect_quantity_to_fail_validation("1 1")
            expect_quantity_to_fail_validation("0 .5")
            expect_quantity_to_fail_validation("0. 5")
          end
        end
      end

      context "valid input" do
        context "input is a decimal" do
          it "passes validation" do
            expect_quantity_to_pass_validation("0.0")
            expect_quantity_to_pass_validation("1.3")
            expect_quantity_to_pass_validation("1.98")
            expect_quantity_to_pass_validation("10.5")
            expect_quantity_to_pass_validation(".25")
          end
        end

        context "input is a fraction" do
          it "passes validation" do
            expect_quantity_to_pass_validation("1/2")
            expect_quantity_to_pass_validation("2/3")
            expect_quantity_to_pass_validation("1/10")
            expect_quantity_to_pass_validation("10/11")
            expect_quantity_to_pass_validation("1 1/2")
            expect_quantity_to_pass_validation("10 1/2")
          end
        end

        context "input is a whole number" do
          it "passes validation" do
            expect_quantity_to_pass_validation("1")
            expect_quantity_to_pass_validation("2")
            expect_quantity_to_pass_validation("23")
            expect_quantity_to_pass_validation("200")
          end
        end

        context "input is a range" do
          xit "passes validation"
        end
      end
    end
  end

  describe "#format_for_display" do
    let(:subject)    { ingredient.format_for_display }
    let(:ingredient) {
      create(
        :ingredient,
        quantity: quantity,
        measurement_unit: measurement_unit
      )
    }
    let(:quantity)         { "1" }
    let(:measurement_unit) { nil }

    context "with measurement unit" do
      let(:measurement_unit) { create(:measurement_unit) }

      context "quantity is greater than 1" do
        let(:quantity) { "1 1/2" }

        it { is_expected.to eq "1 1/2 cups #{ingredient.name.downcase}" }
      end

      context "quantity is less than or equal to 1" do
        let(:quantity) { "1/2" }

        it { is_expected.to eq "1/2 cup #{ingredient.name.downcase}" }
      end
    end

    context "without measurement unit" do
      let(:quantity) { "3" }

      it { is_expected.to eq "3 #{ingredient.name.downcase}" }
    end
  end
end
