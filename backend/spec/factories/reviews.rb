FactoryBot.define do
  factory :review do
    association :restaurant
    reviewer_name { "John Doe" }
    reviewer_email { "john@example.com" }
    rating { 5 }
    comment { "Great food and service!" }
  end
end
