# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:created_issues).class_name("Issue").with_foreign_key("created_by").dependent(:destroy) }
    it { should have_many(:assigned_issues).class_name("Issue").with_foreign_key("assigned_to").dependent(:nullify) }
  end

  describe "validations" do
    subject { build(:user) }  # for uniqueness validation

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(30) }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should allow_value("John Doe").for(:name) }
    it { should allow_value("User-123").for(:name) }
    it { should_not allow_value("Invalid@Name!").for(:name) }
  end

  describe "Devise modules" do
    it "responds to Devise methods" do
      user = build(:user)
      expect(user).to respond_to(:valid_password?)
      expect(user).to respond_to(:remember_me)
      expect(user).to respond_to(:email)
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(build(:user)).to be_valid
    end
  end
end
