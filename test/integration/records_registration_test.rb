require "test_helper"

class RecordsRegistration < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
end

class RecordsRegistrationTest < RecordsRegistration
  def setup
    super
    log_in_as(@user)
    get new_record_path
    assert_template "records/new"
  end
  
  test "successful record(book) registration" do
    assert_difference "Record.count", 1 do
      post records_path, params: { record: { author_name: "ガート・ビースタ著、亘理陽一ほか訳",
                                             main_title: "よい教育研究とはなにか",
                                             sub_title: "流行と正統への批判的考察",
                                             publish_date: 2024,
                                             publisher: "明石書店",
                                             status: "unread",
                                             type: "Book",
                                             memo: "メモの内容",
                                             tags: "音楽,伊沢,明治" } }
    end
    follow_redirect!
    assert_template "records/index"
    assert_match "メモの内容", Record.last.memo
    assert_not flash.empty?
  end

  test "successful record(compilation) registration and deletion" do
    assert_difference "Record.count", 1 do
      post records_path, params: { record: { author_name: "中山裕一郎",
                                             main_title: "音楽教員養成の歴史",
                                             sub_title: "",
                                             publish_date: 1976,
                                             publisher: "音楽之友社",
                                             compiled_by: "浅香淳",
                                             status: "read",
                                             publication_main_title: "音楽教育の歴史",
                                             publication_sub_title: "",
                                             volume_other_form: "音楽教育講座第２巻",
                                             type: "Compilation",
                                             tags: "音楽,伊沢,明治" } }
    end
    follow_redirect!
    assert_template "records/index"
    assert_not flash.empty?
    assert_difference "Record.count", -1 do
      delete record_path(Record.last)
    end
  end

  test "unsuccessful record(paper) registration" do
    assert_no_difference "Record.count" do
      post records_path, params: { record: { author_name: "金井徹",
                                             main_title: "",
                                             sub_title: "西田幾多郎(1940)『日本文化の問題』に関する講義録を手がかりに",
                                             publish_date: 2024,
                                             compiled_by: "教育史学会",
                                             no: 67,
                                             status: "read",
                                             publication_main_title: "日本の教育史学",
                                             publication_sub_title: "",
                                             type: "Paper",
                                             tags: "" } }
    end
    assert_response :unprocessable_entity
    assert_template "records/new"
  end
end

class InvalidRecordsRegistrationTest < RecordsRegistration
  test "create records by not logged-in user" do
    assert_no_difference "Record.count", 1 do
      post records_path, params: { record: { author_name: "ガート・ビースタ著、亘理陽一ほか訳",
                                             main_title: "よい教育研究とはなにか",
                                             sub_title: "流行と正統への批判的考察",
                                             publish_date: 2024,
                                             publisher: "明石書店",
                                             status: "unread",
                                             type: "Book" } }
    end
  end
end

class RecordsEditAndDestroyTest < RecordsRegistration
  def setup
    super
    log_in_as(@user)
    post records_path, params: { record: { author_name: "ガート・ビースタ著、亘理陽一ほか訳",
                                           main_title: "よい教育研究とはなにか",
                                           sub_title: "流行と正統への批判的考察",
                                           publish_date: 2024,
                                           publisher: "明石書店",
                                           status: "unread",
                                           type: "Book" } }
  end

  test "successful edit records" do
    get edit_record_path(Record.last)
    patch record_path(Record.last), params: { record: { author_name: "著者",
                                                      main_title: "よい教育研究とはなにか",
                                                      sub_title: "流行と正統への批判的考察",
                                                      publish_date: 2024,
                                                      publisher: "明石書店",
                                                      status: "unread",
                                                      tags: "音楽, 社会" } }
    assert_redirected_to records_url
    assert_not flash.empty?
  end
end

class InvalidRecordsEditAndDestroyTest < RecordsEditAndDestroyTest
  def setup
    super
    delete logout_path
    log_in_as(@other_user)
  end
  test "destroy records by invalid user" do
    assert_no_difference "Record.count" do
      delete record_path(Record.last)
    end
  end

  test "edit records by invalid user" do
    get edit_record_path(Record.last)
    assert_redirected_to records_path
    assert_not flash.empty?
    patch record_path(Record.last), params: { book: { author_name: "著者",
                                                      main_title: "よい教育研究とはなにか",
                                                      sub_title: "流行と正統への批判的考察",
                                                      publish_date: 2024,
                                                      publisher: "明石書店",
                                                      status: "unread",
                                                      tags: "音楽" } }
    assert_redirected_to records_url
    assert_not flash.empty?
  end
end
