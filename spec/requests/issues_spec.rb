# spec/requests/issues_spec.rb
require "rails_helper"

RSpec.describe "Issues", type: :request do
  let!(:user)    { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:project) { create(:project) }
  let!(:issue)   { create(:issue, project: project, created_by: user.id, assigned_to: other_user.id) }

  before do
    # Devise helper for request specs
    sign_in user, scope: :user
  end

  describe "GET /issues/:id" do
    it "shows a single issue" do
      get issue_path(issue)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(issue.title)
    end
  end

  describe "GET /projects/:project_id/issues/new" do
    it "renders the new issue form" do
      get new_project_issue_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Issue")
    end
  end

  describe "POST /projects/:project_id/issues" do
    context "with valid params" do
      let(:valid_params) do
        {
          issue: {
            title: "New Issue Title",
            description: "Some description",
            status: "open",
            assigned_to: other_user.id
          }
        }
      end

      it "creates a new issue" do
        expect {
          post project_issues_path(project), params: valid_params
        }.to change(Issue, :count).by(1)

        expect(response).to redirect_to(project_path(project))
        follow_redirect!
        expect(response.body).to include("Issue was successfully created.")
      end
    end

    context "with invalid params" do
      let(:invalid_params) do
        {
          issue: { title: "" } # invalid because title is required
        }
      end

      it "does not create a new issue" do
        expect {
          post project_issues_path(project), params: invalid_params
        }.not_to change(Issue, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /issues/:id/edit" do
    it "renders the edit form" do
      get edit_issue_path(issue)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editing Issue")
    end
  end

  describe "PATCH /issues/:id" do
    let(:update_params) do
      { issue: { title: "Updated Title", status: "in_progress" } }
    end

    it "updates the issue" do
      patch issue_path(issue), params: update_params
      expect(response).to redirect_to(issue_path(issue))
      follow_redirect!
      expect(response.body).to include("Issue was successfully updated.")
      expect(issue.reload.title).to eq("Updated Title")
      expect(issue.status).to eq("in_progress")
    end
  end
  describe "PATCH /issues/:id" do
    context "with invalid parameters" do
      let(:invalid_update) do
        { issue: { title: "" } } # blank title will fail validation
      end

      it "does not update the issue and renders edit" do
        patch issue_path(issue), params: invalid_update
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Editing Issue") # or some content in the edit template
        expect(issue.reload.title).not_to eq("")
      end
    end
  end

  describe "DELETE /issues/:id" do
    it "deletes the issue" do
      expect {
        delete issue_path(issue)
      }.to change(Issue, :count).by(-1)

      expect(response).to redirect_to(project_path(project))
      follow_redirect!
      expect(response.body).to include("Issue was successfully destroyed.")
    end
  end
end
