require 'rails_helper'
RSpec.describe Project, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:issues).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3) }
  end

  describe "factories" do
    it "has a valid factory" do
      project = create(:project)
      expect(project).to be_valid
    end
  end
end
