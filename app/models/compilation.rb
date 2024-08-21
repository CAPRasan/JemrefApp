class Compilation < Record
    validates :compiled_by, { presence: true }
    validates :publication_main_title, { presence: true }
end
