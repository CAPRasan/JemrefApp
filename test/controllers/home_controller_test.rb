require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_url
    assert_response :success
    assert_select "title", "ホーム | JemRef"
  end

  test "should get about" do
    get home_about_path
    assert_response :success
    assert_template "home/about"
    assert_select "title", "使い方 | JemRef"
  end

  test "should get information" do
    get home_information_path
    assert_response :success
    assert_template "home/information"
    assert_select "title", "お知らせ・お問い合わせ | JemRef"
  end
end
