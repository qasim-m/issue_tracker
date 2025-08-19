FactoryBot.define do
  factory :project do
    association :user
    name { Faker::App.name }
    description { Faker::Lorem.sentence }
  end
end
