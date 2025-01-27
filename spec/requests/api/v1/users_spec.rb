# spec/controllers/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  # Factory-generated attributes
  let(:valid_attributes) { attributes_for(:user) }
  let(:invalid_attributes) { { name: '', email: 'invalid@example.com', password: '123', password_confirmation: '123' } }

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
end
