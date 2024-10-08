class TagRelationship < ApplicationRecord
    belongs_to :record
    belongs_to :tag
    validates :record_id, presence: true
    validates :tag_id, presence: true
end
