FactoryBot.define do
  factory :menu do
    sequence(:name) { |n| "Menu #{n}" }
    association :restaurant

    trait :with_menu_items do
      after(:create) do |menu|
        menu_items = create_list(:menu_item, 2)
        menu.menu_items = menu_items
      end
    end
  end
end
