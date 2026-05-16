class Post < ApplicationRecord
  include PgSearch::Model
  include Likeable

  belongs_to :user

  validates :user, presence: true
  has_many :comments, dependent: :destroy
  has_many :root_comments, -> { where(parent_id: nil).order(created_at: :asc) }, class_name: "Comment"
  has_one_attached :cover_image

  enum :status, { draft: 0, published: 1 }, default: :draft

  pg_search_scope :search_by_content,
    against: [ :title, :body ],
    using: { tsearch: { prefix: true } }

  validates :title, presence: true, length: { maximum: 200 }
  validates :body, presence: true
  validate :acceptable_cover_image

  def acceptable_cover_image
    return unless cover_image.attached?

    if !cover_image.content_type.in?(%w[image/png image/jpeg image/webp])
      errors.add(:cover_image, "must be a PNG, JPEG, or WebP")
    elsif cover_image.byte_size > 5.megabytes
      errors.add(:cover_image, "must be less than 5 MB")
    end
  end

  scope :published, -> { where(status: :published).order(published_at: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  scope :visible_to, ->(viewer) {
    if viewer&.admin?
      all
    else
      published.or(where(user: viewer))
    end
  }

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
