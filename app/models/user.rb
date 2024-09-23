class User < ApplicationRecord
    has_many :records
    before_save { email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, uniqueness: true,
                      length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  # has_secure_password
end



# create_table "users", force: :cascade do |t|
#     t.string "name"
#     t.string "email"
#     t.string "password"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#   end
