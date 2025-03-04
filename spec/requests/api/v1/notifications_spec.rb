require "rails_helper"

RSpec.describe "Api::V1::Notifications", type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { "Authorization" => "Bearer #{token}" } }
  let(:today) { Date.current }
  let!(:goal) { create(:goal, user: user) }
  let!(:goal_progress) { goal.goal_progresses.find_or_create_by(date: today) }
  let!(:notification) { create(:notification, user: user, goal_progress: goal_progress, read_at: nil) }

  describe "PATCH /api/v1/notifications/:id/mark_as_read" do
    context "when successfully marking a notification as read" do
      it "updates the notification's read_at attribute" do
        expect(notification.read_at).to be_nil

        patch "/api/v1/notifications/#{notification.id}/mark_as_read",
              params: { date: today },
              headers: headers

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["success"]).to eq(true)

        notification.reload
        expect(notification.read_at).to eq(today)
      end
    end

    context "when the notification does not exist" do
      it "returns a 404 error" do
        patch "/api/v1/notifications/99999/mark_as_read",
              params: { date: today },
              headers: headers

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when updating the notification fails" do
      before do
        allow_any_instance_of(Notification).to receive(:update).and_return(false)
      end

      it "returns a 422 error" do
        patch "/api/v1/notifications/#{notification.id}/mark_as_read",
              params: { date: today },
              headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("Failed to update notification")
      end
    end
  end
end

