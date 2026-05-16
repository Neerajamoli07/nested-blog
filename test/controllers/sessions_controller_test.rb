require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "login page" do
    get login_url
    assert_response :success
  end

  test "sign in" do
    post login_url, params: { email: users(:admin).email, password: "password123" }
    assert_redirected_to root_path
  end
end
