class Paper < Record
    validates :publication_main_title, { presence: true }
end
