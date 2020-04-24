FactoryBot.define do
  factory :recipe do
    name { Faker::Food.unique.dish }
    user { User.first || create(:user) }
  end
end
