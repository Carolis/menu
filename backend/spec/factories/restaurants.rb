FactoryBot.define do
  factory :restaurant do
    sequence(:name) { |n| "Restaurant #{n}" }

    trait :with_menus do
      after(:create) do |restaurant|
        create_list(:menu, 2, restaurant: restaurant)
      end
    end
  end
end
