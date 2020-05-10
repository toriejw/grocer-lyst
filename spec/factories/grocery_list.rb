FactoryBot.define do
  factory :grocery_list do
    user { create(:user) }
  end
end
