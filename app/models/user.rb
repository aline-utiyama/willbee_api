require 'active_storage_validations'
class User < ApplicationRecord
  has_secure_password
  has_many :goals, dependent: :destroy
  has_many :goal_plans, foreign_key: :creator_id, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_one_attached :image

  validates :image, content_type: ['image/png', 'image/jpeg']
  validates :name, presence: true
  validates :surname, presence: true
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  # Validate password on create (i.e., when creating a new user)
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validates_confirmation_of :password
  # Allow password to be blank on update (i.e., when updating existing user)
  validates :password, length: { minimum: 6 }, allow_blank: true, on: :update

  def generate_token
    JWT.encode({ user_id: id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end

  def image_url
    image.attached? ? image.url : nil
  end
end
