require "test_helper"

class UsersEdit < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
end

class UsersEditTest < UsersEdit
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path, params: { user: { name: " ",
                                       email: "foo@invalid",
                                       password: "foo",
                                       password_confirmation: "bar" } }
    assert_response :unprocessable_entity
    assert_not flash.empty?
    assert_template "users/edit"
  end

  test "successful edit with friendry forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "foobar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to records_path
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    delete user_path(@user)
    log_in_as(@user)
    assert_template "sessions/new"
  end
end

class UsersEditByInvalidUserTest < UsersEdit
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to records_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                       email: @user.email  } }
    assert_not flash.empty?
    assert_redirected_to records_path
  end
end
