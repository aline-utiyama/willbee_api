require 'active_storage_validations'

class GoalPlan < ApplicationRecord
  belongs_to :creator, class_name: "User"
  has_many :goals
  has_one_attached :image
  validates :image, content_type: ['image/png', 'image/jpeg']

  CATEGORIES = ["Fitness", "Health", "Music", "Personal Growth", "Career", "Sports", "Reading", "Other"]

  validates :title, presence: true
  validates :purpose, presence: true
  validates :repeat_term, inclusion: { in: [ "daily", "weekly", "monthly" ] }
  validates :duration, inclusion: { in: [ "entire_day", "specific_duration" ] }
  validates :category, presence: true, inclusion: { in: CATEGORIES }

  def image_url
    image.attached? ? image.url : nil
  end
end
