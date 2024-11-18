class SampleRecordsCreater
    include RecordsHelper

    def initialize(user)
        @user = user
    end

    def call
            sample_records.each do |sample_record|
              tags_array_sample = extract_tags(sample_record.delete(:tags))  # タグを配列に変換、レコードデータから不要なtagsキーを削除
              record = @user.records.create!(sample_record)           # レコードを作成
              record.save_tags(tags_array_sample)                          # タグを保存
            end
    end
    private
        def sample_records
            [
                { type: "Book", author_name: "夏目漱石", main_title: "文学論",
                sub_title: "", publish_date: 1907, publisher: "大倉書店",
                status: "read", memo: "削除・更新は右のボタンを押してください。", tags: "夏目漱石,文学,明治" },
                { type: "Book", author_name: "三木清", main_title: "哲学ノート",
                sub_title: "", publish_date: 1957, publisher: "新潮社",
                status: "read", memo: "タグはこちらに表示されます。タグをクリックすると、同じタグをもつ文献情報に絞り込みができます。", tags: "三木清,哲学,昭和" },
                { type: "Book", author_name: "伊沢修二", main_title: "教育学",
                sub_title: "", publish_date: 1883, publisher: "丸善商社",
                status: "unread", memo: "これはメモです。", tags: "伊沢修二,教育学,明治,ブリッジウォーター師範学校" },
                { type: "Paper", author_name: "牛山充", main_title: "ミンストレル雑考(一）", sub_title: "",
                publish_date: 1930, publisher: "音楽世界社", compiled_by: "",
                status: "read", publication_main_title: "音楽世界", publication_sub_title: "",
                volume: 2, no: 3, memo: "文献を新しく登録する場合は、ページ最上部の「文献情報の入力」をクリックしてください。", tags: "音楽評論家,音楽雑誌,昭和,音楽史" },
                { type: "Compilation", author_name: "増沢健美", main_title: "音楽史", sub_title: "",
                publish_date: 1927, publisher: "アルス", compiled_by: "小松耕輔（主幹）",
                status: "read", publication_main_title: "アルス西洋音楽講座", publication_sub_title: "",
                volume: 2, memo: "こちらのサンプルは、不要になりましたら削除してください。", tags: "音楽史,1920年代,昭和,音楽評論家" }
            ]
        end
end
