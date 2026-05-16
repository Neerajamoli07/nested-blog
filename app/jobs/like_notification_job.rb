class LikeNotificationJob < ApplicationJob
  queue_as :default

  def perform(like_id)
    like = Like.includes(:user, :likeable).find(like_id)
    actor = like.user
    likeable = like.likeable

    recipient = case likeable
    when Post then likeable.user
    when Comment then likeable.user
    end

    return unless recipient && recipient != actor

    action = likeable.is_a?(Post) ? "like_on_post" : "like_on_comment"

    Notification.create!(
      user: recipient,
      actor: actor,
      notifiable: likeable,
      action: action
    )
  end
end
