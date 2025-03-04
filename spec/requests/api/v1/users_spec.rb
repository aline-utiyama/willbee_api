# spec/controllers/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  # Factory-generated attributes
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { { name: '', email: 'invalid@example.com', password: '123', password_confirmation: '123' } }

  # Test for show
  describe "GET #show" do
    context "when the user is authenticated" do
      let(:user) { create(:user) }
      let(:token) { user.generate_token }

      it "returns the user details" do
        get "/api/v1/users/settings", headers: { "Authorization" => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response["user"]["id"]).to eq(user.id)
        expect(json_response["user"]["name"]).to eq(user.name)
        expect(json_response["user"]["surname"]).to eq(user.surname)
        expect(json_response["user"]["username"]).to eq(user.username)
        expect(json_response["user"]["email"]).to eq(user.email)
      end
    end

    context "when the user is not authenticated" do
      it "returns a 401 error" do
        get "/api/v1/users/settings", headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)["error"]).to eq("Unauthorized")
      end
    end
  end

  # Test for create
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect {
          post '/api/v1/users', params: { user: valid_attributes }, as: :json
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('User created successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect {
          post '/api/v1/users', params: { user: invalid_attributes }, as: :json
        }.to change(User, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
        json = JSON.parse(response.body)
        expect(json['errors']).to include("Username can't be blank", "Password is too short (minimum is 6 characters)")
      end
    end
  end

  # Test for update
  describe "PATCH #update" do
    context "when the user exists" do
      context "with valid parameters" do

        let!(:user) { create(:user) }
        let(:token) { user.generate_token }
        let(:valid_params) do
          {
            id: user.id,
            user: {
              name: "Jane",
              surname: "Smith",
              username: "janesmith"
            }
          }
        end

        it "updates the user successfully" do
          put "/api/v1/users/#{user.id}", params: valid_params, headers: { "Authorization" => "Bearer #{token}" }
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)["message"]).to eq("User updated successfully")
          expect(JSON.parse(response.body)["user"]["name"]).to eq("Jane")
          expect(JSON.parse(response.body)["user"]["surname"]).to eq("Smith")
          expect(JSON.parse(response.body)["user"]["username"]).to eq("janesmith")
        end
      end

      context "with invalid parameters" do
        let!(:user) { create(:user) }
        let(:token) { user.generate_token }
        let(:invalid_params) do
          {
            id: user.id,
            user: {
              name: "",
              surname: "",
              username: ""
            }
          }
        end

        it "returns validation errors" do
          put "/api/v1/users/#{user.id}", params: invalid_params, headers: { "Authorization" => "Bearer #{token}" }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)["errors"]).to include("Name can't be blank")
          expect(JSON.parse(response.body)["errors"]).to include("Surname can't be blank")
          expect(JSON.parse(response.body)["errors"]).to include("Username can't be blank")
        end
      end
    end

    context "when the user does not exist" do
      it "returns a unauthorized error" do
        put "/api/v1/users/9999", params: { id: 9999, user: { name: "Jane", surname: "Smith", username: "janesmith" } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
