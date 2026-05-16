require "test_helper"

class CommentTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "valid root comment" do
    comment = Comment.new(body: "Hello", post: posts(:published_post), user: users(:member))
    assert comment.valid?
  end

  test "enqueues notification job on create" do
    assert_enqueued_with(job: CommentNotificationJob) do
      posts(:published_post).comments.create!(body: "New comment", user: users(:member))
    end
  end
end
