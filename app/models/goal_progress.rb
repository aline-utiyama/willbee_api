class GoalProgress < ApplicationRecord
  belongs_to :goal
  validates :date, uniqueness: { scope: :goal_id, message: "Progress already recorded for this date" }
end
