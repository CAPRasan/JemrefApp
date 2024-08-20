class User < ApplicationRecord
    has_many :records
    validates :name, { presence: true }
    validates :email, { presence: true, uniqueness: true }
    validates :password, { presence: true }
end

# schema
#     t.string "name"
#     t.string "email"
#     t.string "password"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
