class Api::V1::NotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_as_read
    notification = current_user.notifications.find(params[:notification_id])
    if notification.update(read_at: params[:date])
      render json: { success: true }
    else
      render json: { error: "Failed to update notification" }, status: :unprocessable_entity
    end
  end
end
