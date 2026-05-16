class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  after_create_commit :broadcast_to_user

  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current) unless read?
  end

  def message
    case action
    when "comment_on_post"
      "#{actor.name} commented on your post"
    when "reply_to_comment"
      "#{actor.name} replied to your comment"
    when "like_on_post"
      "#{actor.name} liked your post"
    when "like_on_comment"
      "#{actor.name} liked your comment"
    else
      "New activity"
    end
  end

  private

    def broadcast_to_user
      broadcast_prepend_later_to [ user, :notifications ],
        target: "notifications_list",
        partial: "notifications/notification",
        locals: { notification: self }

      broadcast_update_later_to [ user, :notifications ],
        target: "notification_badge",
        partial: "notifications/badge",
        locals: { count: user.notifications.unread.count }
    end
end
