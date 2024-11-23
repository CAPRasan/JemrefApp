class Tag < ApplicationRecord
    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    # タグ付けのバリデーション・アソシエーション
    has_many :tag_relationships, dependent: :destroy
end
