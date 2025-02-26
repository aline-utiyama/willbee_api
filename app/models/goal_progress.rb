class GoalProgress < ApplicationRecord
  belongs_to :goal
  has_one :notification, dependent: :destroy
  
  validates :date, uniqueness: { scope: :goal_id, message: "Progress already recorded for this date" }
end
