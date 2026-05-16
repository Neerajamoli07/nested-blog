class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment_id)
    comment = Comment.includes(:user, :post, :parent).find(comment_id)
    post = comment.post
    actor = comment.user

    if comment.root?
      notify_user(post.user, actor, comment, "comment_on_post") unless post.user == actor
    else
      notify_user(comment.parent.user, actor, comment, "reply_to_comment") unless comment.parent.user == actor
    end

    Rails.logger.info "[CommentNotificationJob] Processed comment ##{comment.id}"
  end

  private

    def notify_user(recipient, actor, comment, action)
      return if recipient == actor

      Notification.create!(
        user: recipient,
        actor: actor,
        notifiable: comment,
        action: action
      )
    end
end
