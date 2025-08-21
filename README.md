# Issue Tracker App

## Ruby and Rails Version
- **Ruby:** 3.3.9
- **Rails:** 8.0.2.1

---
## Local Setup

### Install Dependencies

```bash
bundle install
# Create database
rails db:create
# Run migrations
rails db:migrate
# Seed database
rails db:seed
# Run the App Locally
bundle exec foreman start -f Procfile.dev

---
## Run all test cases
```bash
bundle exec rspec

---
## To run security warnings
```bash
bundle exec brakeman

---
## Production Deploy

### Install Dependencies

```bash

# To deploy this app to Heroku as a collaborator:

# Add Heroku remote
heroku git:remote -a issue-tracker-test-mq
# Commit Procfile for Heroku
git commit -m "Your Commit Message"
# Push code to Heroku
git push heroku main
