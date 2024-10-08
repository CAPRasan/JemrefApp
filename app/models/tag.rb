class Tag < ApplicationRecord
    validates :name, uniqueness: true
    # タグ付けのバリデーション・アソシエーション
    has_many :tag_relationships, dependent: :destroy
end
