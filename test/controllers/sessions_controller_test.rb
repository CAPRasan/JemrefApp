require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "should get login" do
    get login_path
    assert_response :success
  end

  test "successful login and logout" do
    log_in_as(@user)
    assert_not flash.empty?
    assert_redirected_to records_url
    follow_redirect!
    delete logout_path
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_not is_logged_in?
  end
end

class InvalidSessionsTest < SessionsControllerTest
  def setup
    super
  end

  test "login with invalid email" do
    @user.email = "invalid"
    log_in_as(@user)
    assert_response :unprocessable_entity
    assert_template "sessions/new"
  end

  # test "login with invalid password" do
  #   @user.password_digest = "invalid"
  #   log_in_as(@user)
  #   assert_template "sessions/new"
  # end

  test "should redirect login with logged-in user" do
    log_in_as(@user)
    get login_path
    assert_redirected_to records_url
  end

  test "should redirect new with logged-in user" do
    log_in_as(@user)
    get sessions_new_path
    assert_redirected_to records_url
  end

  test "should redirect destroy when not logged-in user" do
    delete logout_path
    assert_redirected_to root_url
  end
end
