class Record < ApplicationRecord
    validates :author_name, { presence: true }
    validates :main_title, { presence: true }
    validates :publish_date, { presence: true }
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
                volume_other_form LIKE ? ",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",
            "%#{keyword}%",)
        else
            all
        end
    end
end
