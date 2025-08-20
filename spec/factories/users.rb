FactoryBot.define do
  factory :user do
    sequence(:name)  { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }       # Devise requires a password
    password_confirmation { "password123" }
  end
end
