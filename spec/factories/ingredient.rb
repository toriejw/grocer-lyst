FactoryBot.define do
  factory :ingredient do
    name   { Faker::Food.ingredient }
    recipe { create(:recipe) }
  end
end
