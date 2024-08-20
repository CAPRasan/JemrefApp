class Record < ApplicationRecord
    belongs_to :user
end



# create_table "records", force: :cascade do |t|
#     t.string "author_name"
#     t.string "main_title"
#     t.string "sub_title"
#     t.integer "publish_date"
#     t.string "publisher"
#     t.string "compiled_by"
#     t.string "publication"
#     t.integer "volume"
#     t.integer "no"
#     t.text "memo"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#     t.integer "status", default: 0, null: false
#     t.integer "user_id"
#     t.index ["user_id"], name: "index_records_on_user_id"
#   end
