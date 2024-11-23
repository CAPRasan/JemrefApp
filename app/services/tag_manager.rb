# テストがほぼできていない、要検討
class TagManager
    def initialize(record, tags_array)
        @record = record
        @tags = tags_array
    end

    # 新規タグ保存
    def save_tags
        @tags.each do |new_tag|
            normalized_tag_name = new_tag.strip.downcase
            tag = Tag.find_or_create_by(name: normalized_tag_name)
            @record.tags << tag unless @record.tags.include?(tag)
        end
    end

    # タグ更新
    def update_tags
        # 既存のタグが存在しない場合
        if !@record.tags.exists?
            @tags.each do |latest_tag|
                # 念の為、空白や英字の大小文字をノーマライズ
                normalized_tag_name = latest_tag.strip.downcase
                tag = Tag.find_or_create_by(name: normalized_tag_name)
                @record.tags << tag unless @record.tags.include?(tag)
            end

        # 更新対象がなかった場合
        elsif @tags.empty? # 既存のタグをすべて削除した場合
            @record.tags.clear

        # 既存のタグも更新対象もある場合、差分を更新
        # ノーマライズできてなかった。
        else
            current_tags = @record.tags.pluck(:name) || []
            latest_tags = @tags || []
            old_tags = current_tags - latest_tags
            new_tags = latest_tags - current_tags

            old_tags.each do |old_tag|
                tag = @record.tags.find_by(name: old_tag)
                @record.tags.delete(tag) if tag.present?
            end
            new_tags.each do |new_tag|
                normalized_tag_name = new_tag.strip.downcase
                tag = Tag.find_or_create_by(name: normalized_tag_name)
                @record.tags << tag unless @record.tags.include?(tag)
            end
        end
    end
end
