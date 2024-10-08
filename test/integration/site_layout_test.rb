require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "header links with no login" do
    get root_path
    assert_template "home/top"
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path, count: 2
    assert_select "a[href=?]", signup_path, count: 2
    assert_select "a[href=?]", home_information_path
  end

  test "should signup with a valid user" do
    get signup_path
    assert_template "users/new"
  end
end

class SiteLayoutWhenLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "header links with login" do
    get records_path
    assert_template "records/index"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", records_path
    assert_select "a[href=?]", new_record_path
  end

  test "invalid action by logged-in user" do
    get login_path
    assert_not flash.empty?
    assert_redirected_to records_url
    get new_user_path
    assert_redirected_to records_url
    assert_not flash.empty?
  end
end
