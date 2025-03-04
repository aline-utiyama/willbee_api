class Goal < ApplicationRecord
  belongs_to :user
  has_many :goal_progresses, dependent: :destroy
  has_many :notifications, through: :goal_progresses

  validates :title, presence: true
  validates :purpose, presence: true
  validates :repeat_term, inclusion: { in: [ "daily", "weekly", "monthly" ] }
  validates :duration, inclusion: { in: [ "entire_day", "specific_duration" ] }
  validates :graph_type, inclusion: { in: [ "dot", "bar" ] }
  validates :set_reminder, inclusion: { in: [ true, false ] }

  after_create :create_initial_goal_progresses

  private

  def create_initial_goal_progresses
    112.times do |i|
      goal_progresses.create!(
        date: next_progress_date(i),
        completed: false
      )
    end
  end

  def next_progress_date(index)
    case repeat_term
    when "daily"
      Date.today + index.days
    when "weekly"
      Date.today + (index * 7).days
    when "monthly"
      Date.today.next_month(index)
    else
      Date.today # Default fallback (should not happen)
    end
  end

end
