require "test_helper"

class RecordSetup < ActiveSupport::TestCase
  def setup
    @record = Record.new(author_name: "michael", main_title: "sample record",
                         publish_date: 2024, publisher: "sample", status: "read", user_id: 1)
    @paper = Paper.new(author_name: "michael", main_title: "sample record",
                       publish_date: 2024, publisher: "sample",
                       publication_main_title: "sample", status: "read", user_id: 1)
    @compilation = Compilation.new(author_name: "michael", main_title: "sample record",
                                   publish_date: 2024, publisher: "sample", compiled_by: "archer",
                                   publication_main_title: "sample", status: "read", user_id: 1)
  end
end

class RecordsValidationTest < RecordSetup
  test "should be valid" do
    assert @record.valid?
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
