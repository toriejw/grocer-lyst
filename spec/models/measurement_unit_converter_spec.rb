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
  end
end
