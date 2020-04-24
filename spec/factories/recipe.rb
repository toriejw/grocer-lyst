FactoryBot.define do
  factory :recipe do
    name { Faker::Food.unique.dish }
    user { create(:user) }
  end
end
