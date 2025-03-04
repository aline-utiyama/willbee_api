require 'rails_helper'

RSpec.describe "Api::V1::Auth", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password123") }

  describe "POST /api/v1/auth/login" do
    context "when credentials are valid" do
      it "returns a JWT token and user details" do
        allow(SendReminderNotificationJob).to receive(:perform_now) # Prevents actual job execution

        post "/api/v1/auth/login", params: { email: user.email, password: "password123" }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response).to have_key("token")
        expect(json_response["user"]["id"]).to eq(user.id)
        expect(json_response["user"]["email"]).to eq(user.email)
        expect(json_response["user"]["name"]).to eq(user.name)

        expect(SendReminderNotificationJob).to have_received(:perform_now) # Ensures job is triggered
      end
    end

    context "when credentials are invalid" do
      it "returns an unauthorized error for incorrect password" do
        post "/api/v1/auth/login", params: { email: user.email, password: "wrongpassword" }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid email or password")
      end

      it "returns an unauthorized error for incorrect email" do
        post "/api/v1/auth/login", params: { email: "wrong@example.com", password: "password123" }

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end

    context "when no credentials are provided" do
      it "returns an unauthorized error" do
        post "/api/v1/auth/login", params: {}

        expect(response).to have_http_status(:unauthorized)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Invalid email or password")
      end
    end
  end
end
