class Goal < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :purpose, presence: true
  validates :repeat_term, inclusion: { in: [ "daily", "weekly", "monthly" ] }
  validates :duration, inclusion: { in: [ "entire_day", "specific_duration" ] }
  validates :graph_type, inclusion: { in: [ "dot", "bar" ] }
  validates :set_reminder, inclusion: { in: [ true, false ] }
end
