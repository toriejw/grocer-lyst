FactoryBot.define do
  factory :grocery_list_item do
    name     { Faker::Food.ingredient }
    quantity { 1.25 }
    grocery_list { create(:grocery_list) }
  end
end
