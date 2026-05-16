require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid post" do
    post = Post.new(title: "Title", body: "Body", user: users(:admin))
    assert post.valid?
  end

  test "publish! sets status and published_at" do
    post = posts(:draft_post)
    post.publish!
    assert post.published?
    assert_not_nil post.published_at
  end

  test "search finds posts" do
    assert_includes Post.published.search_by_content("Published"), posts(:published_post)
  end
end
