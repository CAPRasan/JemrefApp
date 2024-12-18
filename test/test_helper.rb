if ENV["RAILS_ENV"] == "test"
  require "simplecov"
  SimpleCov.start
end
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: 2)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # テストユーザーがログイン中の場合はtrueを返す
    def is_logged_in?
      !session[:user_id].nil?
    end
    # テストユーザーとしてログインする（単体テスト）
    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする（統合テスト）
  def log_in_as(user, password: "password", remember_me: "1")
    post login_path, params: { session: { email: user.email,
                                          password: "password",
                                          remember_me: remember_me } }
  end
end
