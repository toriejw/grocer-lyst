FactoryBot.define do
  factory :recipe do
    name { "Zuchinni bread" }
    user { create(:user) }
  end
end
