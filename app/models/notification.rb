class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :goal_progress
  has_one :goal, through: :goal_progress

  scope :unread, -> { where(read_at: nil) }

  validates :title, :message, presence: true
end
