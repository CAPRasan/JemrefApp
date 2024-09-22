require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test "should get home" do
  get root_path
  assert_template "home/top"
  end
end
