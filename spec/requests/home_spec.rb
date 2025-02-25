require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /index" do
    it "renders the index page" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include('Welcome to Flow')
    end
  end
end
