# spec/factories/comments.rb
FactoryBot.define do
  factory :comment do
    sequence(:text) { |n| "This is a comment #{n}" }

    association :issue
    association :user
  end
end
