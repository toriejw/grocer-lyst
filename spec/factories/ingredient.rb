FactoryBot.define do
  factory :ingredient do
    name   { "zuchinni" }
    recipe { create(:recipe) }
  end
end
