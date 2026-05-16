class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  enum :role, { member: 0, admin: 1 }, default: :member

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }

  normalizes :email, with: ->(email) { email.strip.downcase }

  def admin?
    role == "admin"
  end

  def avatar_thumbnail
    avatar.variant(resize_to_fill: [ 48, 48 ]) if avatar.attached?
  end
end
