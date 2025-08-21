# spec/requests/sessions_spec.rb
require 'rails_helper'

RSpec.describe "User Sessions", type: :request do
  let(:user) { create(:user) }

  describe "GET /users/sign_in" do
    it "renders the login page" do
      get new_user_session_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Log in")
    end
  end

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "signs in the user and redirects" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(authenticated_root_path) # ✅ use authenticated_root_path
        follow_redirect!
        expect(response.body).to include("Signed in successfully")
      end
    end

    context "with invalid credentials" do
      it "does not sign in and re-renders login page" do
        post user_session_path, params: { user: { email: user.email, password: "wrongpass" } }
        expect(response.body).to include("Invalid Email or password")
      end
    end
  end

  describe "DELETE /users/sign_out" do
    before { sign_in user }

    it "logs out the user" do
      delete destroy_user_session_path
      expect(response).to redirect_to(unauthenticated_root_path) # ✅ after logout goes back here
      follow_redirect!
      expect(response.body).to include("Log in")
    end
  end
end
