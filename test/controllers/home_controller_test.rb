require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_url
    assert_response :success
    assert_select "title", "ホーム | JemRef"
  end
end
