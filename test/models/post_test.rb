require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid post" do
    post = Post.new(title: "Title", body: "Body")
    assert post.valid?
  end

  test "requires title and body" do
    post = Post.new
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
    assert_includes post.errors[:body], "can't be blank"
  end

  test "publish! sets status and published_at" do
    post = posts(:draft_post)
    post.publish!
    assert post.published?
    assert_not_nil post.published_at
  end
end
