class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :root_comments, -> { where(parent_id: nil).order(created_at: :asc) }, class_name: "Comment"

  enum :status, { draft: 0, published: 1 }, default: :draft

  validates :title, presence: true, length: { maximum: 200 }
  validates :body, presence: true

  scope :published, -> { where(status: :published).order(published_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  before_save :stamp_published_at, if: :will_save_change_to_status?

  def publish!
    update!(status: :published, published_at: Time.current)
  end

  def published?
    status == "published"
  end

  private

    def stamp_published_at
      self.published_at = published? ? (published_at || Time.current) : nil
    end
end
