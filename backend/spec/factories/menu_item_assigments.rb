FactoryBot.define do
  factory :menu_item_assignment do
    association :menu
    association :menu_item
  end
end
