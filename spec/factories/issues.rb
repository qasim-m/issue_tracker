FactoryBot.define do
  factory :issue do
    sequence(:title) { |n| "Sample Issue #{n}" }
    sequence(:description) { |n| "This is a description for issue #{n}" }
    status { :open }

    association :project
    association :creator, factory: :user
    association :assignee, factory: :user
  end
end
