require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get posts_url
    assert_response :success
  end

  test "should get show" do
    get post_url(posts(:published_post))
    assert_response :success
  end

  test "should create post" do
    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "New", body: "Content", status: "draft" } }
    end
    assert_redirected_to post_url(Post.last)
  end

  test "should publish post" do
    draft = posts(:draft_post)
    patch publish_post_url(draft)
    assert_redirected_to post_url(draft)
    assert draft.reload.published?
  end
end
