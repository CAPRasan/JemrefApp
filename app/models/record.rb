class Record < ApplicationRecord
    validates :author_name, { presence: true }
    validates :main_title, { presence: true }
    validates :publish_date, { presence: true }
    belongs_to :user
    enum :status, { :read=>0, :unread=>1, :unnecessary=>2 }, prefix: true

    def get_title
        if self.sub_title != ""
            title = "#{ self.main_title } ––––#{ self.sub_title }"
        else
            title = "#{ self.main_title }"
        end
        title
    end

    def get_publication_title
        if self.publication_sub_title != ""
            publication_title = "#{ self.publication_main_title } ––––#{ self.publication_sub_title }"
        else
            publication_title = "#{ self.publication_main_title }"
        end
        publication_title
    end

    def get_volume_and_number
        if self.volume && self.no
            volume_and_number = "第#{ volume }巻 第#{ no }号"
        elsif self.volume
            volume_and_number = "第#{ volume }巻"
        elsif self.no
            volume_and_number = "第#{ no }号"
        else voliume_and_number = nil
        end
        volume_and_number
    end

    def self.search(keyword)
        # todo 検索方法について調査必要、現時点では力技フリーワード
        if keyword
            where("
                author_name LIKE ? or
                main_title LIKE ? or
                sub_title LIKE ? or
                publisher LIKE ? or
                compiled_by LIKE ? or
                publication_main_title LIKE ? or
                publication_sub_title LIKE ? or
                volume_other_form LIKE ? ",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",)
        else
            all
        end
    end
end



# ActiveRecord::Schema[7.2].define(version: 2024_08_21_001729) do
#     create_table "records", force: :cascade do |t|
#       t.string "author_name"
#       t.string "main_title"
#       t.string "sub_title"
#       t.integer "publish_date"
#       t.string "publisher"
#       t.string "compiled_by"
#       t.string "publication"
#       t.integer "volume"
#       t.integer "no"
#       t.text "memo"
#       t.datetime "created_at", null: false
#       t.datetime "updated_at", null: false
#       t.integer "status", default: 0, null: false
#       t.integer "user_id"
#       t.string "type"
#       t.string "publication_main_title"
#       t.string "publication_sub_title"
#       t.string "volume_other_form"
#       t.index ["user_id"], name: "index_records_on_user_id"
#     end
