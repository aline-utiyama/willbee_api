class SendReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform
    current_time = Time.current.strftime("%H:%M")

    goals = Goal.where(set_reminder: true).select do |goal|
      goal.repeat_time.strftime("%H:%M") >= current_time
    end

    goals.each do |goal|
      last_progress = goal.goal_progresses.find_or_create_by(date: Date.today)

      # Ensure only one notification per goal progress
      if last_progress.nil? || !last_progress.completed
        notification = Notification.find_or_initialize_by(user: goal.user, goal_progress: last_progress)
        notification.update(
          title: "Reminder",
          message: "Did you complete your #{goal.title} task today?"
        )

        ActionCable.server.broadcast(
          "notifications_#{goal.user.id}",
          { 
            id: notification.id,
            title: notification.title,
            message: notification.message,
            goal_progress_id: last_progress.id
          }
        )
      end
    end
  end
end
