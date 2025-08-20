# spec/factories/projects.rb
FactoryBot.define do
  factory :project do
    sequence(:title) { |n| "Project #{n}" }
    association :user
  end
end
