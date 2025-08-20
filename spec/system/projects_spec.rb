require "rails_helper"

RSpec.describe "Projects management", type: :system do
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


  it "creates a new project" do
    visit new_project_path

    fill_in "Title", with: "Alpha Project"
    click_button "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Alpha Project")
  end

  it "updates an existing project" do
    project = create(:project, user: user, title: "Old Project")

    visit edit_project_path(project)
    fill_in "Title", with: "Updated Project"
    click_button "Update Project"

    expect(page).to have_content("Project was successfully updated.")
    expect(page).to have_content("Updated Project")
  end

end
