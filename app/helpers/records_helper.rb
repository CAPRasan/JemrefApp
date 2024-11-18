module RecordsHelper
    def extract_tags(tags)
        tags = tags.presence || ""
        tags.split(",").map(&:strip)
    end
end
