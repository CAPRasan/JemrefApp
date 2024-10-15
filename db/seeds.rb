User.create!(
   email: ENV["ADMIN_EMAIL"],
   name: ENV["ADMIN_NAME"],
   admin: true,
   password: ENV["ADMIN_PASSWORD"])

Record.create!(
    author_name: "ガート・ビースタ著、亘理陽一ほか訳",
    main_title: "よい教育研究とはなにか",
    sub_title: "流行と正統への批判的考察",
    publish_date: 2024,
    publisher: "明石書店",
    status: "unread",
    user_id: 1,
    type: "Book"
)

Book.create!(
    author_name: "奥中康人",
    main_title: "国家と音楽",
    sub_title: "伊沢修二がめざした近代",
    publish_date: 2008,
    publisher: "春秋社",
    status: "read",
    user_id: 1
)

Paper.create!(
    author_name: "金井徹",
    main_title: "務台理作における日本文化論の検討",
    sub_title: "西田幾多郎(1940)『日本文化の問題』に関する講義録を手がかりに",
    publish_date: 2024,
    compiled_by: "教育史学会",
    no: 67,
    status: "read",
    user_id: 1,
    publication_main_title: "日本の教育史学",
    publication_sub_title: ""
)

Compilation.create!(
    author_name: "中山裕一郎",
    main_title: "音楽教員養成の歴史",
    sub_title: "",
    publish_date: 1976,
    publisher: "音楽之友社",
    compiled_by: "浅香淳",
    status: "read",
    user_id: 1,
    publication_main_title: "音楽教育の歴史",
    publication_sub_title: "",
    volume_other_form: "音楽教育講座第２巻"
)

# 状態readの書誌情報（本）をランダムで30件作成
30.times do |n|
    author_name = Faker::Book.author
    main_title = Faker::Book.title
    sub_title = Faker::Book.title
    publish_date = rand(1900..2024)
    publisher = Faker::Book.publisher


    Book.create!(author_name: author_name,
                 main_title: main_title,
                 sub_title: sub_title,
                 publish_date: publish_date,
                 publisher: publisher,
                 status: "read",
                 user_id: 1
                 )
end

# 状態readの書誌情報（編著）をランダムで30件作成
30.times do |n|
    author_name = Faker::Book.author
    main_title = Faker::Book.title
    sub_title = Faker::Book.title
    publish_date = rand(1900..2024)
    publisher = Faker::Book.publisher
    compiled_by = Faker::Book.author
    publication_main_title = Faker::Book.title
    volume = rand(1..24)
    no = rand(1..12)


    Compilation.create!(author_name: author_name,
                 main_title: main_title,
                 sub_title: sub_title,
                 publish_date: publish_date,
                 publisher: publisher,
                 compiled_by: compiled_by,
                 publication_main_title: publication_main_title,
                 publication_sub_title: "",
                 volume: volume,
                 no: no,
                 status: "unread",
                 user_id: 1,
                 )
end
