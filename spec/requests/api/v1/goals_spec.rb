require 'rails_helper'

RSpec.describe "Api::V1::Goals", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:goal_params) do
    {
      title: "Learn Ruby",
      purpose: "Improve programming skills",
      repeat_term: "daily",
      repeat_time: "09:00",
      advice: "Start with basic syntax",
      set_reminder: true,
      reminder_minutes: 30,
      duration: "specific_duration",
      duration_length: 60,
      duration_measure: "minutes",
      graph_type: "dot",
      is_private: true
    }
  end
  let!(:goal) { create(:goal, user: user) }

  describe "GET #index" do
    it "returns all goals of the user" do
      get "/api/v1/goals", params: {}, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns the requested goal" do
      get "/api/v1/goals/#{goal.id}", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["title"]).to eq(goal.title)
    end

    it "returns a 404 error when the goal is not found" do
      get "/api/v1/goals/9999",  headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Goal not found")
    end
  end

  describe "POST #create" do
    it "creates a new goal" do
      expect {
        post "/api/v1/goals", params: { goal: goal_params }, headers: { "Authorization" => "Bearer #{token}" }
      }.to change(Goal, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns an error when goal is invalid" do
      post "/api/v1/goals", params: { goal: goal_params.merge(title: nil) }, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
    end
  end

  describe "PUT #update" do
    it "updates the goal" do
      put "/api/v1/goals/#{goal.id}", params: { id: goal.id, goal: { title: "Updated Title" } }, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(goal.reload.title).to eq("Updated Title")
    end

    it "returns an error if goal is invalid" do
      put "/api/v1/goals/#{goal.id}", params: { id: goal.id, goal: { title: nil } }, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the goal" do
      expect {
        delete "/api/v1/goals/#{goal.id}", params: { id: goal.id }, headers: { "Authorization" => "Bearer #{token}" }
      }.to change(Goal, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    context "when the goal does not exist" do
      it "returns a 404 error" do
        delete "/api/v1/goals/9999", headers: { "Authorization" => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("Goal not found")
      end
    end
  end
end
