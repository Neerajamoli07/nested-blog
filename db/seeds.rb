puts "Seeding blog data..."

post1 = Post.find_or_create_by!(title: "Welcome to Rails 8 Blog") do |post|
  post.body = <<~BODY
    This blog application demonstrates Rails 8.1 with Hotwire, nested comments,
    Turbo Streams, Stimulus controllers, Solid Queue background jobs, and
    PostgreSQL-backed Solid Cache and Solid Cable.

    Create posts, publish them, and join threaded discussions with nested replies
  up to four levels deep—all without full page reloads.
  BODY
  post.status = :published
  post.published_at = 1.day.ago
end

post2 = Post.find_or_create_by!(title: "Draft: Upcoming Features") do |post|
  post.body = "This post is still a draft. Publish it from the post page when ready."
  post.status = :draft
end

if post1.comments.none?
  root = post1.comments.create!(body: "Great intro! How deep can comment threads go?")
  reply = root.replies.create!(post: post1, body: "Up to 4 levels of nesting, powered by a self-referential parent_id.")
  reply.replies.create!(post: post1, body: "Nice—Turbo Streams append replies in real time.")
  post1.comments.create!(body: "Solid Queue processes comment notifications in the background.")
end

puts "Created #{Post.count} posts and #{Comment.count} comments."
