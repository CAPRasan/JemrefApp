class Record < ApplicationRecord
    validates :author_name, { presence: true }
    validates :main_title, { presence: true }
    validates :publish_date, { presence: true }
    has_many :tag_relationships, dependent: :destroy
    has_many :tags, through: :tag_relationships
    belongs_to :user
    # この書法は非推奨、要修正
    enum :status, { read: 0, unread: 1, unnecessary: 2 }, prefix: true

    def get_title
        if self.sub_title != ""
            title = "#{ self.main_title } 　━#{ self.sub_title }━"
        else
            title = "#{ self.main_title }"
        end
        title
    end

    def get_publication_title
        if self.publication_sub_title != ""
            publication_title = "#{ self.publication_main_title }　 ━#{ self.publication_sub_title }━"
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

    # 新規タグづけ用のメソッド
    def save_tags(tags)
        tags.each do |new_tag|
            normalized_tag_name = new_tag.strip.downcase
            tag = Tag.find_or_create_by(name: normalized_tag_name)
            self.tags << tag unless self.tags.include?(tag)
        end
    end
    # タグ更新用のメソッド
    def update_tags(latest_tags)
        # 既存のタグが存在しない場合
        if !self.tags.exists?
            latest_tags.each do |latest_tag|
                # 念の為、空白や英字の大小文字をノーマライズ
                normalized_tag_name = latest_tag.strip.downcase
                tag = Tag.find_or_create_by(name: normalized_tag_name)
                self.tags << tag unless self.tags.include?(tag)
            end
        # 更新対象がなかった場合
        elsif latest_tags.nil?
            nil # nilなら何もしない
        elsif latest_tags.empty?
            self.tags.clear # 既存のタグをすべて削除
        else
            # 既存のタグも更新対象もある場合、差分を更新
            current_tags = self.tags.pluck(:name)
            current_tags ||= []  # nilの場合は空の配列にする
            latest_tags ||= []   # 同上

            old_tags = current_tags - latest_tags
            new_tags = latest_tags - current_tags

            old_tags.each do |old_tag|
                tag = self.tags.find_by(name: old_tag)
                self.tags.delete(tag) if tag.present?
            end
            new_tags.each do |new_tag|
                tag = Tag.find_or_create_by(name: new_tag.strip)
                self.tags << tag unless self.tags.include?(tag)
            end
        end
    end

    # 同じタグを持つレコードを返すメソッド
    def self.tagged_with(tag_name, user)
        tag = Tag.find_by(name: tag_name)
        return [] unless tag
        records = user.records.joins(:tags).where(tags: { id: tag.id })
        records
    end

    # フリーワード検索のためのメソッド
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
                volume_other_form LIKE ? or
                memo LIKE ?",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%")
        else
            all
        end
    end
end
