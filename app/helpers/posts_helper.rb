module PostsHelper
  def post_status_badge(post)
    tag.span post.status.humanize,
      class: "badge badge--#{post.status}"
  end

  def format_post_date(post)
    (post.published_at || post.created_at).strftime("%B %d, %Y")
  end
end
