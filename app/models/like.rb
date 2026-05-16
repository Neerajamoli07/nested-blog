class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: [ :likeable_type, :likeable_id ] }

  after_create_commit -> { LikeNotificationJob.perform_later(id) }
end
