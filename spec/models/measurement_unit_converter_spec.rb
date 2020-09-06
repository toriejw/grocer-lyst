require "rails_helper"

describe MeasurementUnitConverter do
  describe ".can_convert_between?" do
    let(:subject) { described_class.can_convert_between?(measurement_type1, measurement_type2) }
    let(:measurement_type1) { nil }
    let(:measurement_type2) { nil }

    context "nil and anything" do
      let(:measurement_type1) { :cup }

      it { should be false }
    end

    context "tablespoon and teaspoon" do
      let(:measurement_type1) { :teaspoon }
      let(:measurement_type2) { :tablespoon }

      it { should be true }
    end

    context "ounce and cup" do
      let(:measurement_type1) { :ounce }
      let(:measurement_type2) { :cup }

      it { should be true }
    end

    context "ounce and teaspoon" do
      let(:measurement_type1) { :ounce }
      let(:measurement_type2) { :teaspoon }

      it { should be false }
    end
  end

  describe ".convert" do
    let(:subject) {
      described_class.convert(from: measurement_type1, to: measurement_type2, quantity: quantity)
    }
    let(:measurement_type1) { nil }
    let(:measurement_type2) { nil }
    let(:quantity)          { nil }

    context "ounces to cups" do
      let(:measurement_type1) { :ounce }
      let(:measurement_type2) { :cup }
      let(:quantity)          { 8 }

      it "converts correctly" do
        expect(subject).to eq 1
      end
    end

    context "cups to ounces" do
      let(:measurement_type1) { :cup }
      let(:measurement_type2) { :ounce }
      let(:quantity)          { 5 }

      it "converts correctly" do
        expect(subject).to eq 40
      end
    end
  end
end
