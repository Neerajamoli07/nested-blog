ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    parallelize(workers: ENV["CI"] ? 1 : :number_of_processors)

    fixtures :all
  end
end

module SignInHelper
  def sign_in_as(user)
    post login_path, params: { email: user.email, password: "password123" }
  end
end

class ActionDispatch::IntegrationTest
  include SignInHelper
end
