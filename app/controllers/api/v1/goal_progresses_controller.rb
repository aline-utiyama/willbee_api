class Api::V1::GoalProgressesController < ApplicationController
  before_action :authenticate_user!

  def complete_today
    goal = current_user.goals.find(params[:goal_id])
    today = params[:date_today]

    # Find the goal progress by today's date
    goal_progress = goal.goal_progresses.find_or_initialize_by(date: today)
    # Set completed as true
    goal_progress.completed = true
    # Set checked as today's date
    goal_progress.checked_at = today

    # Calculate the streak value
    goal_progress.current_streak = calculate_streak(goal)
    goal_progress.longest_streak = [goal_progress.current_streak, goal.goal_progresses.maximum(:longest_streak) || 0].max


    if goal_progress.save
      render json: { message: "Goal progress marked as completed", goal_progress: goal_progress }, status: :ok
    else
      render json: { error: "Failed to update goal progress" }, status: :unprocessable_entity
    end
  end

  def complete_progress_through_notifications

    today = params[:date_today]

    # Find the goal progress and notification
    goal_progress = GoalProgress.find(params[:goal_progress_id])
    notification = Notification.find(params[:notification_id])

    # Set completed as true
    goal_progress.completed = true
    # Set checked as today's date
    goal_progress.checked_at = today

    # # Calculate the streak value
    goal_progress.current_streak = calculate_streak(goal_progress.goal)
    goal_progress.longest_streak = [goal_progress.current_streak, goal_progress.goal.goal_progresses.maximum(:longest_streak) || 0].max


    if goal_progress.save
      notification.read_at = today
      notification.save
      render json: { message: "Goal progress marked as completed", goal_progress: goal_progress }, status: :ok
    else
      render json: { error: "Failed to update goal progress" }, status: :unprocessable_entity
    end
  end

  private

  def calculate_streak(goal)
    # Get the last recorded progress before today
    last_progress = goal.goal_progresses.where("date < ?", Date.current).order(date: :desc).first

    # If there’s no previous progress or it was missed, reset the streak
    if last_progress.nil? || !last_progress.completed
      return 0
    else
      return last_progress.current_streak + 1
    end
  end
end
