require "test_helper"

class CommentTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "valid root comment" do
    comment = Comment.new(body: "Hello", post: posts(:published_post))
    assert comment.valid?
  end

  test "nested reply belongs to parent" do
    reply = comments(:reply_comment)
    assert_equal comments(:root_comment), reply.parent
    assert reply.parent.root?
  end

  test "depth calculation" do
    assert_equal 0, comments(:root_comment).depth
    assert_equal 1, comments(:reply_comment).depth
  end

  test "enqueues notification job on create" do
    assert_enqueued_with(job: CommentNotificationJob) do
      posts(:published_post).comments.create!(body: "New comment")
    end
  end

  test "updates post comments_count" do
    post = posts(:published_post)
    initial = post.comments_count
    post.comments.create!(body: "Another comment")
    assert_equal initial + 1, post.reload.comments_count
  end
end
