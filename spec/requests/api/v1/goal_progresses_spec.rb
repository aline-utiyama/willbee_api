require "rails_helper"

RSpec.describe "Api::V1::GoalProgresses", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }
  let(:today) { Date.current }
  let!(:goal) { create(:goal, user: user) }
  let(:goal_progress) { goal.goal_progresses.find_by(date: today) } # Find today's goal progress
  let!(:notification) { create(:notification, user: user, goal_progress: goal_progress) }

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

  describe "PATCH /api/v1/goal_progresses/complete_progress_through_notifications" do
    context "when successfully marking goal progress as completed" do
      it "updates goal progress and marks notification as read" do
        expect {
          patch "/api/v1/goal_progresses/#{goal_progress.id}/complete_progress_through_notifications",
               params: { date_today: today, notification_id: notification.id },
               headers: headers
        }.not_to change(GoalProgress, :count)

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["message"]).to eq("Goal progress marked as completed")

        goal_progress.reload
        notification.reload

        expect(goal_progress.completed).to be_truthy
        expect(goal_progress.checked_at).to eq(today)
        expect(notification.read_at).to eq(today)
      end
    end

    context "when the goal progress does not exist" do
      it "returns a 404 error" do
        patch "/api/v1/goal_progresses/99999/complete_progress_through_notifications",
             params: { date_today: today, notification_id: notification.id },
             headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when the notification does not exist" do
      it "returns a 404 error" do
        patch "/api/v1/goal_progresses/#{goal_progress.id}/complete_progress_through_notifications",
             params: { date_today: today, notification_id: 99999 },
             headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when saving the goal progress fails" do
      before do
        allow_any_instance_of(GoalProgress).to receive(:save).and_return(false)
      end

      it "returns a 422 error" do
        patch "/api/v1/goal_progresses/#{goal_progress.id}/complete_progress_through_notifications",
             params: { date_today: today, notification_id: notification.id },
             headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Failed to update goal progress")
      end
    end
  end

  describe "#calculate_streak" do

    it "returns 0 when there is no completed progress" do
      
      goal_progress.reload # Ensure we get the latest version from DB
      expect(goal_progress.current_streak).to eq(0)
    end
    
    it "returns 1 when there is only one completed progress" do
      goal_progress.update!(completed: true) # Instead of creating a new one

      patch "/api/v1/goal_progresses/complete_today",
           params: { goal_id: goal.id, date_today: today },
           headers: headers

      goal_progress.reload # Ensure we get the latest version from DB
      expect(goal_progress.current_streak).to eq(1)
    end

    it "calculates the streak correctly for consecutive days" do
      goal.goal_progresses.find_by(date: today)&.update!(completed: true)
      goal.goal_progresses.find_by(date: today + 1.day)&.update!(completed: true)
      goal.goal_progresses.find_by(date: today + 2.day)&.update!(completed: true)
      goal_progress.update!(completed: true)

      patch "/api/v1/goal_progresses/complete_today",
           params: { goal_id: goal.id, date_today: today },
           headers: headers

      goal_progress.reload
      expect(goal.goal_progresses.maximum(:current_streak)).to eq(3)
    end
  end
end
