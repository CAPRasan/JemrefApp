require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "get top page" do
    get root_path
    assert_response :success
    assert_template "home/top"
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path, count: 2
    assert_select "a[href=?]", signup_path, count: 2
    assert_select "a[href=?]", home_information_path
    assert_select "a[href=?]", home_about_path
    assert_select "a[href=?]", home_information_path
  end

  test "get about page" do
    get home_about_path
    assert_response :success
    assert_template "home/about"
  end

  test "get information page" do
    get home_information_path
    assert_response :success
    assert_template "home/information"
    assert_select "a[href=?]", "https://docs.google.com/forms/d/e/1FAIpQLScSf402YZiHTyHW-DkTEDNKOpOGzmKygJaf_YVdxqz23fndWg/viewform?usp=sf_link"
  end
end
