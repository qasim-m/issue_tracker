# spec/models/comment_spec.rb
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:issue) { create(:issue, project: project, creator: user) }

  describe "associations" do
    it { should belong_to(:issue) }
    it { should belong_to(:user) }
  end

  describe "factory" do
    it "has a valid factory" do
      comment = build(:comment, issue: issue, user: user)
      expect(comment).to be_valid
    end
  end
end
