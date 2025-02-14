class GoalPlan < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :goals

  validates :title, presence: true
  validates :purpose, presence: true
  validates :repeat_term, inclusion: { in: [ "daily", "weekly", "monthly" ] }
  validates :duration, inclusion: { in: [ "entire_day", "specific_duration" ] }
end
