puts "Seeding..."

admin = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin"
  u.password = "password123"
  u.role = :admin
end
admin.update!(password: "password123", role: :admin) unless admin.admin?

member = User.find_or_create_by!(email: "member@example.com") do |u|
  u.name = "Alex Writer"
  u.password = "password123"
end

Post.where(user_id: nil).update_all(user_id: admin.id)
Comment.where(user_id: nil).update_all(user_id: member.id)

post1 = Post.find_or_create_by!(title: "Welcome to the Real-Time Blog") do |post|
  post.user = admin
  post.body = <<~BODY
    This app demonstrates Rails 8 with authentication, nested comments, live updates
    via Action Cable, notifications, image uploads, search, likes, and an admin dashboard.

    Open this post in two browser windows and watch comments appear instantly.
  BODY
  post.status = :published
  post.published_at = 2.days.ago
end
post1.update!(user: admin, status: :published) unless post1.user

post2 = Post.find_or_create_by!(title: "Building with Hotwire") do |post|
  post.user = member
  post.body = "Turbo Streams and Stimulus power live comments and notifications without a heavy JavaScript framework."
  post.status = :published
  post.published_at = 1.day.ago
end

if post1.comments.none?
  root = post1.comments.create!(user: member, body: "Love the live comment feature!")
  root.replies.create!(post: post1, user: admin, body: "Thanks! Try replying from another browser tab.")
  post1.comments.create!(user: member, body: "Search and likes work great too.")
end

puts "Done. Log in as admin@example.com or member@example.com (password: password123)"
