require "test_helper"

class RecordsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "index including pagination" do
    log_in_as(@user)
    get records_path
    assert_template "records/index"
    assert_select "ul.pagination"
    assigns(:records).paginate(page: 1).each do |record|
      assert_select "h5", text: "#{record.author_name}（#{record.publish_date}）"
      assert_select "a[href=?]", edit_record_path(record)
    end
  end
end
