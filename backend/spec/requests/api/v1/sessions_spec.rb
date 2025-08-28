require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/auth/verify" do
    let(:valid_credentials) { { username: 'admin', password: 'password' } }
    let(:invalid_credentials) { { username: 'wrong', password: 'wrong' } }

    context "with valid credentials" do
      it "returns success response" do
        auth_header = ActionController::HttpAuthentication::Basic.encode_credentials(
          valid_credentials[:username],
          valid_credentials[:password]
        )

        post "/api/v1/auth/verify", headers: { 'Authorization' => auth_header }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['authenticated']).to be true
        expect(json_response['message']).to eq("Authentication successful")
      end
    end

    context "with invalid credentials" do
      it "returns unauthorized response" do
        auth_header = ActionController::HttpAuthentication::Basic.encode_credentials(
          invalid_credentials[:username],
          invalid_credentials[:password]
        )

        post "/api/v1/auth/verify", headers: { 'Authorization' => auth_header }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("HTTP Basic: Access denied")
      end
    end

    context "without credentials" do
      it "returns unauthorized response" do
        post "/api/v1/auth/verify"

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include("HTTP Basic: Access denied")
      end
    end

    context "with custom environment credentials" do
      before do
        allow(ENV).to receive(:fetch).with('ADMIN_USERNAME', 'admin').and_return('custom_admin')
        allow(ENV).to receive(:fetch).with('ADMIN_PASSWORD', 'password').and_return('custom_pass')
      end

      it "uses custom credentials from environment" do
        auth_header = ActionController::HttpAuthentication::Basic.encode_credentials(
          'custom_admin',
          'custom_pass'
        )

        post "/api/v1/auth/verify", headers: { 'Authorization' => auth_header }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['authenticated']).to be true
      end
    end
  end
end
