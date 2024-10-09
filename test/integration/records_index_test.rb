require "test_helper"

class RecordsIndex < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
    post records_path, params: { record: {
      author_name: "ガート・ビースタ著、亘理陽一ほか訳",
      main_title: "よい教育研究とはなにか",
      sub_title: "流行と正統への批判的考察",
      publish_date: 2024,
      publisher: "明石書店",
      status: "unread",
      type: "Book",
      memo: "メモの内容",
      tags: "音楽, 伊沢" # フィクスチャで定義したタグ名
    } }
  end
end

class RecordIndexTest < RecordsIndex
  test "index including pagination" do
    get records_path
    assert_template "records/index"
    assert_select "ul.pagination"
    assigns(:records).paginate(page: 1).each do |record|
      assert_select "h5", text: "#{record.author_name}（#{record.publish_date}）"
      assert_select "a[href=?]", edit_record_path(record)
    end
  end

  test "keyword search" do
    get records_path, params: { keyword: "音楽" }
    assert_template "records/index"
    assert_match "奥中康人", response.body
  end

  test "tag search" do
    get records_path, params: { tag_name: "音楽" }
    assert_template "records/index"
    assert_match "明石書店", response.body
  end
end
