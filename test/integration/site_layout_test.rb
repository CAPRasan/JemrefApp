require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "header links with no login" do
    get home_about_path
    assert_template "home/about"
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", signup_path, count: 1
    assert_select "a[href=?]", home_information_path
    assert_select "a[href=?]", home_about_path
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
    @other_user = users(:archer)
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
    assert_select "a[href=?]", home_about_path
    assert_select "a[href=?]", home_information_path
    assert_select "a[href=?]", edit_user_path(@user)
  end

  test "invalid action by logged-in user" do
    # ログインページにアクセス
    get login_path
    assert_not flash.empty?
    assert_redirected_to records_url
    # サインアップページにアクセス
    get new_user_path
    assert_redirected_to records_url
    assert_not flash.empty?
    # 他のユーザーのeditページにアクセス
    get edit_user_path(@other_user)
    assert_not flash.empty?
    assert_redirected_to records_url
  end
end
