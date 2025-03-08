class SendReminderNotificationJob < ApplicationJob
  queue_as :default

  def perform
    current_time = Time.now.strftime("%H:%M")

    goals = Goal.where(set_reminder: true).select do |goal|
      # goal.reminder_minutes represents how many minutes before the reminder should be sent
      remind_before_minutes = goal.reminder_minutes.minutes

      # Set the exact reminder time, by subtracting remind_before_minutes from goal.repeat_time
      reminder_time = (goal.repeat_time - remind_before_minutes).strftime("%H:%M")

      # Extract only the goals where the current time is greater or equal to reminder_time
      current_time >= reminder_time
    end

    # Iterate over each goal
    goals.each do |goal|
      # Remove old notifications (not from today)
      goal.user.notifications.where.not(created_at: Date.today.all_day).destroy_all

      # Get the goal progress that matches today's date
      todays_progress = goal.goal_progresses.find_or_create_by(date: Date.today)

      # Ensure only one notification per goal progress
      if !todays_progress.completed
        # Get the progress notification
        notification = Notification.find_or_initialize_by(user: goal.user, goal_progress: todays_progress)

        notification.update(
          title: "Reminder",
          message: "Did you complete your #{goal.title} task today?"
        )

        # Send the notification, only if the notification is not read yet.
        if notification.read_at.nil?
          ActionCable.server.broadcast(
            "notifications_#{goal.user.id}",
            {
              id: notification.id,
              title: notification.title,
              message: notification.message,
              goal_progress_id: todays_progress.id
            }
          )
        end
      end
    end
  end
end
