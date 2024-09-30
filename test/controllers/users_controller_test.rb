require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:michael)
    end

    test "should get login" do
        get login_path
        assert_response :success
        assert_template "sessions/new"
        assert_select "title", "ログイン | JemRef"
    end

    test "should get signup" do
        get signup_path
        assert_response :success
        assert_template "users/new"
        assert_select "title", "新規登録 | JemRef"
    end

    test "should redirect edit when not logged in" do
        get edit_user_path(@user)
        assert_not flash.empty?
        assert_redirected_to login_url
    end

    test "should redirect update when not logged in" do
        patch user_path(@user), params: { user: { name: @user.name,
                                                  email: @user.email } }
        assert_not flash.empty?
        assert_redirected_to login_url
    end
end
