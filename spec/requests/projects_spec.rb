# spec/requests/projects_spec.rb
require 'rails_helper'

RSpec.describe "Projects", type: :request do
  let(:user) { create(:user) }
  before do
    # Devise helper for request specs
    sign_in user, scope: :user
  end
  let!(:project) { create(:project, user: user) }




  describe "GET /projects" do
    it "lists all projects" do
      get projects_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(project.title)
    end
  end

  describe "GET /projects/:id" do
    it "shows a project" do
      get project_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(project.title)
    end
  end

  describe "GET /projects/new" do
    it "renders the new project form" do
      get new_project_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Project")
    end
  end

  describe "GET /projects/:id/edit" do
    it "renders the edit project form" do
      get edit_project_path(project)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editing Project")
    end
  end

  describe "POST /projects" do
    context "with valid parameters" do
      let(:valid_params) { { project: { title: "New Project" } } }

      it "creates a new project" do
        expect {
          post projects_path, params: valid_params
        }.to change(Project, :count).by(1)

        new_project = Project.last
        expect(new_project.user).to eq(user)
        expect(response).to redirect_to(project_path(new_project))
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { project: { title: "" } } }

      it "does not create a project and renders new" do
        expect {
          post projects_path, params: invalid_params
        }.not_to change(Project, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("New Project")
      end
    end
  end

  describe "PATCH /projects/:id" do
    context "with valid parameters" do
      let(:valid_update) { { project: { title: "Updated Title" } } }

      it "updates the project" do
        patch project_path(project), params: valid_update
        expect(response).to redirect_to(project_path(project))
        project.reload
        expect(project.title).to eq("Updated Title")
      end
    end

    context "with invalid parameters" do
      let(:invalid_update) { { project: { title: "" } } }

      it "does not update the project and renders edit" do
        patch project_path(project), params: invalid_update
        expect(response).to have_http_status(:unprocessable_entity)
        project.reload
        expect(project.title).not_to eq("")
      end
    end
  end

  describe "DELETE /projects/:id" do
    it "deletes the project" do
      expect {
        delete project_path(project)
      }.to change(Project, :count).by(-1)
      expect(response).to redirect_to(projects_path)
    end
  end
end
