class User < ApplicationRecord
    has_many :records
    validates :name, { presence: true }
    validates :email, { presence: true, uniqueness: true }
    has_secure_password
end



# create_table "users", force: :cascade do |t|
#     t.string "name"
#     t.string "email"
#     t.string "password"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#   end
