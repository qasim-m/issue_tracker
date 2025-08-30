require "rails_helper"

RSpec.describe "Issues management", type: :system do
  include Warden::Test::Helpers
  let(:user) { create(:user) }

  before do
    driven_by(:rack_test)
    Warden.test_mode!
    login_as(user, scope: :user)
  end

  after do
    Warden.test_reset!
  end

  it "creates a new issue within a project" do
    project = create(:project, user: user)

    visit new_project_issue_path(project)

    fill_in "Issue Title", with: "Login Bug"
    fill_in "Description", with: "Login page fails with 500 error"
    click_button "Create Issue"

    expect(page).to have_content("Issue was successfully created.")
    expect(page).to have_content("Login Bug")
  end

  it "updates an existing issue" do
    project = create(:project, user: user)
    issue = create(:issue, title: "Old Title", description: "Some desc", project: project)

    visit edit_issue_path(issue)
    fill_in "Issue Title", with: "Updated Issue"
    fill_in "Description", with: "Updated description"
    click_button "Update Issue"

    expect(page).to have_content("Issue was successfully updated.")
    expect(page).to have_content("Updated Issue")
  end
end
