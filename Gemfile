source "https://rubygems.org"
ruby "3.3.9"
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "tailwindcss-ruby", "~> 4.1.11"
gem "tailwindcss-rails", "~> 4.3"
gem "activerecord", "~> 8.0"
gem "pg", "~> 1.6.2"
gem "foreman", "~> 0.90.0"
gem "devise", "~> 4.9"
gem "view_component", "~> 3.12"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  gem "byebug", "~> 12.0"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
  gem "rspec-rails", "~> 8.0.2"   # For Rails 8 support
  gem "factory_bot_rails"       # Factories for test data
  gem "faker"                   # Fake data generation
  gem "shoulda-matchers"        # One-liner tests for models
  gem "simplecov", require: false  # Test coverage reports
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "rails-controller-testing"
end
