require 'rails_helper'

RSpec.describe Api::V1::GoalPlansController, type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:goal_plan_params) do
    {
      title: "Morning Workout",
      purpose: "Stay fit and healthy",
      repeat_term: "daily",
      repeat_time: "07:00",
      advice: "Start with stretching",
      category: "Health",
      duration: "specific_duration",
      duration_length: 30,
      duration_measure: "minutes"
    }
  end
  let!(:goal_plan) { create(:goal_plan, creator: user) }

  describe "GET #index" do
    it "returns all goal plans" do
      get "/api/v1/goal_plans", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
    end

    it "returns only goal plans for a specific category" do
      get "/api/v1/goal_plans", params: { category: "Health" }, headers: { "Authorization" => "Bearer #{token}" }
      
      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)
      
      expect(json_response.length).to eq(1)
      expect(json_response.first["category"]).to eq("Health")
    end
  end

  describe "GET #show" do
    it "returns the requested goal plan" do
      get "/api/v1/goal_plans/#{goal_plan.id}", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)["title"]).to eq(goal_plan.title)
    end

    it "returns a 404 error when the goal plan is not found" do
      get "/api/v1/goal_plans/9999", headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Goal Plan not found")
    end
  end

  describe "POST #create" do
    it "creates a new goal plan" do
      expect {
        post "/api/v1/goal_plans", params: { goal_plan: goal_plan_params }, headers: { "Authorization" => "Bearer #{token}" }
      }.to change(GoalPlan, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "returns an error when goal plan is invalid" do
      post "/api/v1/goal_plans", params: { goal_plan: goal_plan_params.merge(title: nil) }, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
    end
  end

  describe "PUT #update" do
    it "updates the goal plan" do
      put "/api/v1/goal_plans/#{goal_plan.id}", params: { id: goal_plan.id, goal_plan: { title: "Updated Title" } }, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:success)
      expect(goal_plan.reload.title).to eq("Updated Title")
    end

    it "returns an error if goal plan is invalid" do
      put "/api/v1/goal_plans/#{goal_plan.id}", params: { id: goal_plan.id, goal_plan: { title: nil } }, headers: { "Authorization" => "Bearer #{token}" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)["errors"]).to include("Title can't be blank")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the goal plan" do
      expect {
        delete "/api/v1/goal_plans/#{goal_plan.id}", params: { id: goal_plan.id }, headers: { "Authorization" => "Bearer #{token}" }
      }.to change(GoalPlan, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    let(:other_user) { create(:user, email: "otheruser@test.com", username: "otheruser") } # A different user
    let(:other_token) { other_user.generate_token }

    it "prevents a user from deleting someone else's goal plan" do
      delete "/api/v1/goal_plans/#{goal_plan.id}", headers: { "Authorization" => "Bearer #{other_token}" }

      expect(response).to have_http_status(:forbidden)
      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("You can only delete your own goal plans.")
      expect(GoalPlan.exists?(goal_plan.id)).to be_truthy # Ensure the record still exists
    end
  end
end
