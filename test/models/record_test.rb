require "test_helper"

class RecordSetup < ActiveSupport::TestCase
  def setup
    @record = Record.new(author_name: "michael", main_title: "主題", sub_title: "副題",
                         publish_date: 2024, publisher: "sample", status: "read", user_id: 1)
    @paper = Paper.new(author_name: "michael", main_title: "sample record",
                       publish_date: 2024, publisher: "sample",
                       publication_main_title: "出版物主題", publication_sub_title: "",
                       volume: "2", status: "read", user_id: 1)
    @compilation = Compilation.new(author_name: "michael", main_title: "sample record",
                                   publish_date: 2024, publisher: "sample", compiled_by: "archer",
                                   publication_main_title: "出版物主題", publication_sub_title: "出版物副題",
                                   status: "read", user_id: 1)
  end
end

class RecordsValidationTest < RecordSetup
  test "should be valid" do
    assert @record.valid?
    assert @paper.valid?
    assert @compilation.valid?
  end

  test "author name should be present" do
    @record.author_name = " "
    assert_not @record.valid?
  end

  test "main title should be present" do
    @record.main_title = " "
    assert_not @record.valid?
  end

  test "publish date should be present" do
    @record.publish_date = nil
    assert_not @record.valid?
  end

  test "publication main title of papers should be present" do
    @paper.publication_main_title = " "
    assert_not @paper.valid?
  end

  test "compiled_by of compilation should be present" do
    @compilation.compiled_by = " "
    assert_not @compilation.valid?
  end
end

class RecordsMethodTest < RecordSetup
  test "get title(japanese)" do
    assert_equal @record.get_title, "主題 　━副題━"
  end

  test "get publication title(japanese)" do
    assert_equal @paper.get_publication_title, "出版物主題"
    assert_equal @compilation.get_publication_title, "出版物主題 　━出版物副題━"
  end

  test "get volume and number(japanese)" do
    assert_equal @paper.get_volume_and_number, "第2巻"
  end
end
