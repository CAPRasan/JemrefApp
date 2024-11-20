require "test_helper"

class RecordsIndex < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
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
      assert_select "button", text: "サンプルデータを入力", count: 0
    end
  end

  test "keyword search" do
    get records_path, params: { q: { author_name_or_main_title_or_sub_title_or_publisher_or_publication_main_title_or_publication_sub_title_or_compiled_by_or_memo_cont: "教育研究" } }
    assert_template "records/index"
    assert_match "ビースタ", response.body
  end

  test "advanced search" do
    get records_path, params: { q: { main_title_or_sub_title_cont: "教育研究", publisher_cont: "明石" } }
    assert_match "流行と正統", response.body
  end

  test "tag search" do
    get records_path, params: { tag_name: "音楽" }
    assert_template "records/index"
    assert_match "明石書店", response.body
  end
end

class RecordsSampleTest < RecordsIndex
  test "add sample records" do
    delete logout_path
    log_in_as(@other_user)
    get records_path
    assert_response :success
    assert_select "button", text: "サンプルデータを入力"
    assert_difference "Record.count", 5 do
      post records_create_sample_path
    end
  end

  test "should not show add sample records button" do
    log_in_as(@user)
    get records_path, params: { q: { main_title_or_sub_title_cont: "userのレコードに存在しないタイトル" } }
    assert_response :success
    assert_match "全 0 件の文献情報", response.body
    assert_select "button", text: "サンプルデータを入力", count: 0
  end
end
