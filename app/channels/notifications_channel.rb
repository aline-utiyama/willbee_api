class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "notifications_#{params[:user_id]}"

    # Send all unread notifications
    notifications = Notification.where(user_id: params[:user_id], read_at: nil)
    notifications.each do |notification|
      transmit({
        id: notification.id,
        goal_progress_id: notification.goal_progress_id,
        title: notification.title,
        message: notification.message,
        created_at: notification.created_at,
        goal_id: notification.goal.id
      })
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
