require 'rails_helper'

RSpec.describe Issue, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  describe "associations" do
    it { should belong_to(:project) }
    it { should belong_to(:creator).class_name("User").with_foreign_key("created_by") }
    it { should belong_to(:assignee).class_name("User").with_foreign_key("assigned_to").optional }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }
  end

  describe "enums" do
    it do
      should define_enum_for(:status)
        .with_values(open: 0, in_progress: 1, on_hold: 2, closed: 3)
        .backed_by_column_of_type(:integer)
    end
  end

  describe "callbacks" do
    it "auto-increments issue_number per project" do
      issue1 = create(:issue, project: project, creator: user)
      issue2 = create(:issue, project: project, creator: user)
      expect(issue2.issue_number).to eq(issue1.issue_number + 1)
    end
  end

  describe "factory" do
    it "has a valid factory" do
      issue = build(:issue, project: project, creator: user)
      expect(issue).to be_valid
    end
  end
end
