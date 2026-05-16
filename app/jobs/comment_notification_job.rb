class CommentNotificationJob < ApplicationJob
  queue_as :default

  def perform(comment_id)
    comment = Comment.find(comment_id)
    Rails.logger.info "[CommentNotificationJob] New #{comment.root? ? 'comment' : 'reply'} on post ##{comment.post_id}"
  end
end
