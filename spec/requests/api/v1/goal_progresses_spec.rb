require "rails_helper"

RSpec.describe "Api::V1::GoalProgresses", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }
  let(:today) { Date.current }
  let!(:goal) { create(:goal, user: user) }
  let(:goal_progress) { goal.goal_progresses.find_by(date: today) } # Find today's goal progress

  describe "POST /api/v1/goal_progresses/complete_today" do
    context "when marking today's goal progress as completed" do
      it "updates the existing goal progress record" do
        expect {
          patch "/api/v1/goal_progresses/complete_today",
               params: { goal_id: goal.id, date_today: today },
               headers: headers
        }.not_to change(goal.goal_progresses, :count) # No new record, just an update

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Goal progress marked as completed")

        # Check that today's goal progress was updated
        goal_progress.reload
        expect(goal_progress.completed).to be_truthy
        expect(goal_progress.checked_at).to eq(today)
      end
    end

    context "when the goal does not exist" do
      it "returns a 404 error" do
        patch "/api/v1/goal_progresses/complete_today",
             params: { goal_id: 99999, date_today: today },
             headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when saving the goal progress fails" do
      before do
        allow_any_instance_of(GoalProgress).to receive(:save).and_return(false)
      end

      it "returns a 422 error" do
        patch "/api/v1/goal_progresses/complete_today",
             params: { goal_id: goal.id, date_today: today },
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Failed to update goal progress")
      end
    end
  end
end
