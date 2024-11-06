require "test_helper"

class RecordsControllerSetup < ActionDispatch::IntegrationTest
    def setup
        @user = users(:michael)
        @other_user = users(:archer)
        @book = records(:book1) 
    end
end

class RecordsControllerTest < RecordsControllerSetup
    def setup
        super
        log_in_as(@user)
        follow_redirect!
    end

    test "should get index" do
        assert_template "records/index"
        assert_not flash.empty?
    end

    test "should get new" do
        get new_record_path
        assert_response :success
        assert_template "records/new"
    end

    test "should get edit" do
        get edit_record_path(@book)
        assert_response :success
        assert_template "records/edit"
    end
end

class InvalidAccess < RecordsControllerSetup
    def setup
        super
    end

    test "should redirect index when not logged in" do
        get records_path
        assert_redirected_to login_url
    end
end
