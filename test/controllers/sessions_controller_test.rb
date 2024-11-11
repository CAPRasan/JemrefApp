require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get login_path
    assert_response :success
  end
end

class InvalidSessionsTest < SessionsControllerTest
  def setup
    @user = users(:michael)
  end

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
