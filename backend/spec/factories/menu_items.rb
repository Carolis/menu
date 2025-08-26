FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Menu Item #{n}" }
    price { 9.99 }
    association :menu
  end
end
