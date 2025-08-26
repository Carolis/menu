FactoryBot.define do
  factory :menu do
    sequence(:name) { |n| "Menu #{n}" }

    trait :with_menu_items do
      after(:create) do |menu|
        create_list(:menu_item, 2, menu: menu)
      end
    end
  end
end
