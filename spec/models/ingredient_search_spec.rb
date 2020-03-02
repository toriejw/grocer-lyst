require "rails_helper"

describe IngredientSearch do
  let(:subject) { described_class.new(query) }

  describe ".results" do
    def expect_results_to_contain(results, ingredient_name)
      expect(results.any? { |result| result.name == ingredient_name }).to be true
    end

    context "valid query is provided" do
      before do
        Ingredient.create!(name: "apple")
        Ingredient.create!(name: "apricot")
        Ingredient.create!(name: "chocolate")
      end

      context "query matches only first letter" do
        let(:query) { "a" }

        it "returns all matching ingredients" do
          results = subject.results

          expect(results.count).to eq 2
          expect_results_to_contain(results, "apple")
          expect_results_to_contain(results, "apricot")
        end

        # this case is technically covered in the above test, but I'm including
        # it as a guard rail against future changes
        it "does not match ingredients that contain but do not start with the letter" do
          results = subject.results

          expect(results.count).to eq 2
          expect(results.any? { |result| result.name == "chocolate" }).to be false
        end
      end

      context "query matches the first few letters" do
        let(:query) { "apr" }

        it "returns all matching ingredients" do
          results = subject.results

          expect(results.count).to eq 1
          expect_results_to_contain(results, "apricot")
        end
      end

      context "query is a full match" do
        let(:query) { "chocolate" }

        it "returns all matching ingredients" do
          results = subject.results

          expect(results.count).to eq 1
          expect_results_to_contain(results, query)
        end
      end

      context "query matches no ingredients" do
        let(:query) { "peanut butter" }

        it "returns nothing" do
          expect(subject.results).to eq []
        end
      end

      context "query is empty string" do
        let(:query) { "" }

        it "returns nothing" do
          expect(subject.results).to eq []
        end
      end

      context "nil query is provided" do
        let(:query) { nil }

        it "returns nothing" do
          expect(subject.results).to eq []
        end
      end

      context "for large result sets" do
        let(:query) { "a" }

        before do
          Ingredient.create!(name: "apple")
          Ingredient.create!(name: "apricot")
          Ingredient.create!(name: "almond")
          Ingredient.create!(name: "arugula")
          Ingredient.create!(name: "avacado")
          Ingredient.create!(name: "allspice")
        end

        it "limits results returned to 5" do
          expect(subject.results.count).to eq 5
        end
      end
    end

    context "invalid query is provided" do
      context "query contains special characters" do
        let(:query) { "a*" }

        before do
          Ingredient.create!(name: "apple")
        end

        it "removes them from the query" do
          results = subject.results

          expect(results.count).to eq 1
          expect(results.first.name).to eq "apple"
        end
      end

      context "query contains SQLI attempt" do
        let(:query) { "a' OR 1='1" }

        before do
          Ingredient.create!(name: "orange")
        end

        it "does not return the maliciously desired results" do
          expect(subject.results).to eq []
        end
      end
    end
  end
end
