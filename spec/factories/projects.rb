FactoryBot.define do
  factory :project do
    association :user
    title { Faker::App.name }
  end
end
