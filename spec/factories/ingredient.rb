FactoryBot.define do
  factory :ingredient do
    name   { Faker::Food.ingredient }
    recipe { Recipe.first || create(:recipe) }
  end
end
