require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
    test "should get login" do
        get login_path
        assert_response :success
        assert_template "users/login_form"
        assert_select "title", "ログイン | JemRef"
    end

    test "should get signup" do
        get signup_path
        assert_response :success
        assert_template "users/new"
        assert_select "title", "新規登録 | JemRef"
    end
end
