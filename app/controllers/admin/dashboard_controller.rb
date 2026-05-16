module Admin
  class DashboardController < BaseController
    def show
      @stats = {
        users: User.count,
        posts: Post.count,
        published_posts: Post.published.count,
        comments: Comment.count,
        likes: Like.count,
        notifications: Notification.count
      }
      @recent_users = User.order(created_at: :desc).limit(5)
      @recent_posts = Post.includes(:user).order(created_at: :desc).limit(5)
    end
  end
end
