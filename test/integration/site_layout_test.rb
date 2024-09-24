require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "header links with no login" do
    get root_path
    assert_template "home/top"
    assert_select "a[href=?]", root_path
    # assert_select "a[href=?]", login_path, count: 2
    # assert_select "a[href=?]", signup_path, count: 2
  end

  test "should signup with a valid user" do
    get signup_path
    assert_template "users/new"
  end
end
