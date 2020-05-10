require "rails_helper"

describe Amount, type: :model do
  let(:amount)           { Amount.new(quantity, measurement_unit) }
  let(:quantity)         { "1" }
  let(:measurement_unit) { nil }

  describe ".can_convert_between?" do
    let(:subject) { described_class.can_convert_between?(amount, amount2) }
    let(:amount2) { Amount.new(quantity2, measurement_unit2) }
    let(:quantity2) { "1" }
    let(:measurement_unit2) { nil }

    context "measurement units are the same" do
      context "measurement units are nil" do
        it { should be true }
      end

      context "measurement units are not nil" do
        let(:measurement_unit)  { create(:measurement_unit) }
        let(:measurement_unit2) { measurement_unit }

        it { should be true }
      end
    end

    context "measurement units are different" do
      context "nil and anything" do
        let(:measurement_unit2) { create(:measurement_unit) }

        it { should be false }
      end
    end
  end

  describe "#+" do
    let(:additional_amount) {
      Amount.new(additional_quantity, additional_measurement_unit)
    }
    let(:additional_quantity) { "1 3/4" }
    let(:additional_measurement_unit) { nil }

    context "quantity is unparsable" do
      it "raises an error"
    end

    context "quantities are the same data type" do
      let(:quantity) { 2 }
      let(:additional_quantity) { 8 }

      it "combines the quantities" do
        combined_amount = amount + additional_amount

        expect(combined_amount.to_f).to eq 10
      end
    end

    context "quantities are different data types" do
      let(:quantity) { "1/2" }
      let(:additional_quantity) { 8 }

      it "combines the quantities" do
        combined_amount = amount + additional_amount

        expect(combined_amount.to_f).to eq 8.5
      end
    end

    context "neither amount has a measurement_unit" do
      it "combines the quantities" do
        combined_amount = amount + additional_amount

        expect(combined_amount.to_f).to eq 2.75
        expect(combined_amount.measurement_unit).to eq nil
      end
    end

    context "amounts have the same measurement_unit" do
      let(:measurement_unit) { create(:measurement_unit) }
      let(:additional_measurement_unit) { measurement_unit }
      let(:quantity) { 2.5 }
      let(:additional_quantity) { "4.2" }

      it "combines the quantities" do
        combined_amount = amount + additional_amount

        expect(combined_amount.to_f).to eq 6.7
      end

      it "returns the original measurement_unit" do
        combined_amount = amount + additional_amount

        expect(combined_amount.measurement_unit).to eq measurement_unit
      end
    end

    context "amounts have different measurement_units" do
      context "measurement_units can be compared" do
        context "for teaspoons and tablespoons" do
          let(:measurement_unit) { create(:measurement_unit, name: "tablespoon") }
          let(:additional_measurement_unit) { create(:measurement_unit, name: "teaspoon") }

          it "combines the quantities"
          it "returns tablespoon as the measurement_unit"
        end

        context "for teaspoons and cups" do
          let(:measurement_unit) { create(:measurement_unit, name: "cup") }
          let(:additional_measurement_unit) { create(:measurement_unit, name: "teaspoon") }

          it "combines the quantities"
          it "returns cup as the measurement_unit"
        end

        context "for tablespoons and cups" do
          let(:measurement_unit) { create(:measurement_unit, name: "tablespoon") }
          let(:additional_measurement_unit) { create(:measurement_unit, name: "cup") }

          it "combines the quantities"
          it "returns cup as the measurement_unit"
        end

      end

      context "measurement_units cannot be compared" do
        let(:measurement_unit) { create(:measurement_unit) }
        let(:additional_measurement_unit) { create(:measurement_unit, name: "incomparable") }

        it "raises an error" do
          expect {
            combined_amount = amount + additional_amount
          }.to raise_error(/Cannot convert between/)
        end
      end
    end
  end

  describe "#<=>" do
    let(:subject)           { amount <=> comparison_amount }
    let(:comparison_amount) { Amount.new(comparison_quantity, nil) }

    context "amounts are equal" do
      let(:comparison_quantity) { quantity }

      it { is_expected.to eq 0 }
    end

    context "comparison amount is larger" do
      let(:comparison_quantity) { "1 1/2" }

      it { is_expected.to eq -1 }
    end

    context "comparison amount is smaller" do
      let(:comparison_quantity) { "0.75" }

      it { is_expected.to eq 1 }
    end

    context "comparison is not of type Amount" do
      let(:subject) { amount <=> 1 }

      it { is_expected.to eq nil }
    end
  end

  describe "#to_s" do
    let(:subject) { amount.to_s }

    context "with measurement unit" do
      let(:measurement_unit) { create(:measurement_unit) }

      context "quantity is greater than 1" do
        let(:quantity) { "1 1/2" }

        it { is_expected.to eq "1 1/2 cups" }
      end

      context "quantity is less than or equal to 1" do
        let(:quantity) { "1/2" }

        it { is_expected.to eq "1/2 cup" }
      end

      context "quantity is decimal" do
        let(:quantity) { "1.5" }

        it { is_expected.to eq "1.5 cups" }
      end
    end

    context "without measurement unit" do
      context "quantity is greater than 1" do
        let(:quantity) { "3" }

        it { is_expected.to eq "3" }
      end

      context "quantity is less than or equal to 1" do
        let(:quantity) { "1/2" }

        it { is_expected.to eq "1/2" }
      end
    end
  end
end
