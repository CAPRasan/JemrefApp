require "test_helper"

class UsersLogin < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
end

class InvalidPasswordTest < UsersLogin
  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", password: "" } }
    assert_response :unprocessable_entity
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid email/invalid password" do
    post login_path, params: { session: { email: @user.email,
                                          password: "invalid" } }
    assert_response :unprocessable_entity
    assert_template "sessions/new"
    assert_not flash.empty?
  end
end

class ValidLogin < UsersLogin
  def setup
    super
    post login_path, params: { session: { email: @user.email,
                                          password: "password" } }
  end
end

class ValidLoginTest < ValidLogin
  test "login with valid information followed by logout" do
    assert is_logged_in?
    assert_redirected_to records_path
    follow_redirect!
    assert_template "records/index"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
  end
end

class Logout < ValidLogin
  def setup
    super
    delete logout_path
  end
end

class LogoutTest < Logout
  test "successful logout" do
    assert_not is_logged_in?
    assert_response :see_other
    assert_redirected_to root_url
  end

  test "redirect after logout" do
    follow_redirect!
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path, count: 2
    assert_select "a[href=?]", signup_path, count: 2
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "should still work after logout in second window" do
    delete logout_path
    assert_redirected_to root_url
  end

  class RememberingTest < UsersLogin
    test "login with remembering" do
      log_in_as(@user, remember_me: "1")
      assert_equal cookies[:remember_token], assigns(:user).remember_token
    end

    test "login without remembering" do
      log_in_as(@user, remember_me: "1")
      delete logout_path
      log_in_as(@user, remember_me: "0")
      assert cookies[:remember_me].blank?
    end
  end
end
