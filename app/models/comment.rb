class Comment < ApplicationRecord
  include Likeable

  belongs_to :post, counter_cache: true
  belongs_to :user

  validates :user, presence: true
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  validates :body, presence: true, length: { maximum: 5000 }

  after_create_commit :notify_participants
  after_create_commit :broadcast_comment
  after_destroy_commit :broadcast_remove_comment

  scope :roots, -> { where(parent_id: nil) }

  def root?
    parent_id.nil?
  end

  def depth
    parent ? parent.depth + 1 : 0
  end

  def broadcast_target
    root? ? "comments" : ActionView::RecordIdentifier.dom_id(parent, :replies)
  end

  private

    def notify_participants
      CommentNotificationJob.perform_later(id)
    end

    def broadcast_comment
      broadcast_append_later_to post,
        target: broadcast_target,
        partial: "comments/comment",
        locals: { comment: self, current_user: nil }
    end

    def broadcast_remove_comment
      broadcast_remove_to post, target: self
    end
end
