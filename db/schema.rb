# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_15_035247) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "records", force: :cascade do |t|
    t.string "author_name"
    t.string "main_title"
    t.string "sub_title"
    t.integer "publish_date"
    t.string "publisher"
    t.string "compiled_by"
    t.integer "volume"
    t.integer "no"
    t.text "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.bigint "user_id"
    t.string "type"
    t.string "publication_main_title"
    t.string "publication_sub_title"
    t.string "volume_other_form"
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "tag_relationships", force: :cascade do |t|
    t.bigint "record_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_tag_relationships_on_record_id"
    t.index ["tag_id"], name: "index_tag_relationships_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "records", "users"
  add_foreign_key "tag_relationships", "records"
  add_foreign_key "tag_relationships", "tags"
end
