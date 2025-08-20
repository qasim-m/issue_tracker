# spec/requests/comments_spec.rb
require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user)  { create(:user) }
  let(:issue) { create(:issue) }

   before do
    # Devise helper for request specs
    sign_in user, scope: :user
  end


  describe "POST /issues/:issue_id/comments" do
    context "with valid parameters" do
      let(:valid_params) { { comment: { text: "This is a test comment" } } }

      it "creates a new comment" do
        expect {
          post issue_comments_path(issue), params: valid_params
        }.to change(Comment, :count).by(1)
        expect(response).to redirect_to(issue_path(issue))
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) { { comment: { text: "" } } }

      it "does not create a comment and renders issue show page" do
        expect {
          post issue_comments_path(issue), params: invalid_params
        }.not_to change(Comment, :count)
        expect(response).to have_http_status(:unprocessable_content)
        expect(response.body).to include(issue.title)
      end
    end
  end
end
