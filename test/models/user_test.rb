require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(name: "Test", email: "test@example.com", password: "password123")
    assert user.valid?
  end

  test "admin role" do
    assert users(:admin).admin?
    assert_not users(:member).admin?
  end
end
