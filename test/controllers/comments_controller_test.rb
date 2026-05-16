require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:published_post)
  end

  test "should create root comment via turbo stream" do
    assert_difference("Comment.count") do
      post post_comments_url(@post), params: { comment: { body: "Turbo comment" } }, as: :turbo_stream
    end
    assert_response :success
  end

  test "should create nested reply" do
    parent = comments(:root_comment)
    assert_difference("Comment.count") do
      post post_comments_url(@post),
           params: { comment: { body: "Nested reply", parent_id: parent.id } },
           as: :turbo_stream
    end
    assert_response :success
    assert_equal parent, Comment.last.parent
  end

  test "should destroy comment" do
    comment = comments(:root_comment)
    assert_difference("Comment.count", -2) do
      delete post_comment_url(@post, comment), as: :turbo_stream
    end
    assert_response :success
  end
end
