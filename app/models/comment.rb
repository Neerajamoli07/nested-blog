class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent

  validates :body, presence: true, length: { maximum: 5000 }

  after_create_commit -> { CommentNotificationJob.perform_later(id) }

  scope :roots, -> { where(parent_id: nil) }

  def root?
    parent_id.nil?
  end

  def depth
    parent ? parent.depth + 1 : 0
  end
end
