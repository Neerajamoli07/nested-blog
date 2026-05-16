module Likeable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :likeable, dependent: :destroy
  end

  def liked_by?(user)
    return false unless user

    likes.exists?(user: user)
  end
end
