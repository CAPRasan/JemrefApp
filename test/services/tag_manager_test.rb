require "test_helper"
class TagManagerSetup < ActiveSupport::TestCase
    def setup
        @record = Record.create!(
        author_name: "ガート・ビースタ著、亘理陽一ほか訳",
        main_title: "よい教育研究とはなにか",
        sub_title: "流行と正統への批判的考察",
        publish_date: 2024,
        publisher: "明石書店",
        status: "unread",
        type: "Book",
        memo: "メモの内容",
        user_id: 1
        )
        @tag1 = [ "Music" ]
        @tag2 = [ "FineArt", "Singing" ]
    end
end

class TagManagerTest < TagManagerSetup
    def setup
        super
    end

    test "save tags" do
        tag_manager = TagManager.new(@record, @tag1)
        assert_difference "@record.tags.count", 1 do
            tag_manager.save_tags
        end
    end

    test "update / delete tags" do
        tag_manager1 = TagManager.new(@record, @tag1)
        tag_manager1.save_tags
        assert_includes @record.tags.pluck(:name), "music"

        tag_manager2 = TagManager.new(@record, @tag2)
        tag_manager2.update_tags
        assert_includes @record.tags.pluck(:name), "fineart"
        assert_not_includes @record.tags.pluck(:name), "music"

        assert_difference "@record.tags.count", -2 do
            tag_manager3 = TagManager.new(@record, [])
            tag_manager3.update_tags
        end
    end

    test "normalized tags" do
        tag_manager = TagManager.new(@record, [ "  mixed  ", "TAG1  " ])
        tag_manager.save_tags
        assert_includes @record.tags.pluck(:name), "mixed"
        assert_includes @record.tags.pluck(:name), "tag1"
    end
end
