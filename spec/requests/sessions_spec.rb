require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login page" do
      get login_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Welcome Back')
    end
  end

  describe "GET /auth/google_oauth2/callback" do
    let(:auth_hash) do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '123456',
        info: {
          email: 'test@example.com',
          name: 'Test User'
        }
      })
    end

    before do
      auth_hash # initialize the auth hash
    end

    context "when user exists" do
      let!(:user) { create(:user, email: 'test@example.com') }

      it "logs in the existing user" do
        get '/auth/google_oauth2/callback'
        expect(session[:user_id]).to eq(user.id)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user does not exist" do
      it "creates a new user and logs them in" do
        expect {
          get '/auth/google_oauth2/callback'
        }.to change(User, :count).by(1)

        expect(session[:user_id]).to eq(User.last.id)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET /logout" do
    let(:user) { create(:user) }

    it "logs out the user" do
      # Set up a session
      post login_path, params: { session: { user_id: user.id } }
      session[:user_id] = user.id

      # Perform logout
      get "/logout"

      # Verify the session is cleared
      expect(response).to redirect_to(root_path)
      follow_redirect!
      expect(session[:user_id]).to be_nil
    end
  end
end
