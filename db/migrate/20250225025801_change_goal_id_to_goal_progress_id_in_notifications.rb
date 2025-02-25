class ChangeGoalIdToGoalProgressIdInNotifications < ActiveRecord::Migration[8.0]
  def change
    remove_reference :notifications, :goal, index: true, foreign_key: true
    add_reference :notifications, :goal_progress, foreign_key: true, null: false
  end
end
