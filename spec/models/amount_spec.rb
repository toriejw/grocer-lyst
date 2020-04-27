require "rails_helper"

describe Amount, type: :model do
  let(:amount)           { Amount.new(quantity, measurement_unit) }
  let(:quantity)         { "1" }
  let(:measurement_unit) { nil }

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
