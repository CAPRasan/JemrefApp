require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:michael)
        @other_user = users(:archer)
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

    test "should redirect destroy when not logged in" do
        assert_no_difference "User.count" do
            delete user_path(@user)
        end
        assert_redirected_to records_url
    end

    test "should redirect destroy when logged in an other user" do
        log_in_as(@other_user)
        assert_no_difference "User.count" do
            delete user_path(@user)
        end
        assert_redirected_to records_url
    end

    test "successful destroy" do
        log_in_as(@user)
        assert_difference "User.count", -1 do
            delete user_path(@user)
        end
        assert_redirected_to root_url
    end

    test "should not allow the admin attribute to be edited via web" do
        log_in_as(@other_user)
        assert_not @other_user.admin?
        patch user_path(@other_user), params: { user: { password: "password",
                                                        password_confirmation: "password",
                                                        admin: true } }
        assert_not @other_user.reload.admin?
    end
end
