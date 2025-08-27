FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Menu Item #{n}" }
    price { 9.99 }

    trait :on_menu do
      after(:create) do |menu_item|
        menu = create(:menu)
        menu.menu_items << menu_item
      end
    end
  end
end
