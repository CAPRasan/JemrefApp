# テスト要実装
class Record < ApplicationRecord
    validates :author_name, { presence: true }
    validates :main_title, { presence: true }
    validates :publish_date, { presence: true }
    validates :status, { presence: true }
    has_many :tag_relationships, dependent: :destroy
    has_many :tags, through: :tag_relationships
    belongs_to :user

    enum :status, { read: 0, unread: 1, unnecessary: 2 }, prefix: true

    # TODO: 日本語用のみ、英語対応のさい要修正。
    def get_title
        # TODO: 念の為、nilのケースも追加しておく
        if self.sub_title != ""
            title = "#{ self.main_title } 　━#{ self.sub_title }━"
        else
            title = "#{ self.main_title }"
        end
        title
    end

    def get_publication_title
        if self.publication_sub_title != ""
            publication_title = "#{ self.publication_main_title } 　━#{ self.publication_sub_title }━"
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

    # 同じタグを持つレコードを返すメソッド
    # TODO: 検索されたタグしか返せなくなる？要検証。
    def self.tagged_with(tag_name, user)
        tag = Tag.find_by(name: tag_name)
        return [] unless tag
        user.records.joins(:tags).where(tags: { id: tag.id })
    end

    # 新規タグづけ用のメソッド
    def save_tags(tags)
        TagManager.new(self, tags).save_tags
    end
    # タグ更新用のメソッド
    def update_tags(latest_tags)
        TagManager.new(self, latest_tags).update_tags
    end

    private
        # ransack検索フォーム用クラスメソッド
        def self.ransackable_attributes(auth_object = nil)[
            "author_name",
            "main_title",
            "sub_title",
            "publisher",
            "publication_main_title",
            "publication_sub_title",
            "compiled_by",
            "memo",
            "created_at",
            "no",
            "publish_date",
            "status",
            "volume",
            "volume_other_form"
        ]
        end

        def self.ransackable_associations(auth_object = nil)
            [ "tag_relationships", "tags", "user" ]
        end
end
