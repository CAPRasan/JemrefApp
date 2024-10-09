class RecordsController < ApplicationController
  before_action :logged_in_user
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    @keyword = search_params[:keyword]
    @tag_name = search_params[:tag_name]
    records = if @keyword.present?
                 current_user.records.search(@keyword)
    elsif @tag_name.present?
                 Record.tagged_with(@tag_name, current_user)
    else
                 current_user.records # 検索パラメータがない場合のデフォルト
    end
    @records = records.order(:publish_date).paginate(page: params[:page], per_page: 20)
  end


  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    # 入力したタグ名を受け取れるようにする（タグだけテーブルが異なるため）
    tags_array = extract_tags(params[:record][:tags])
    @record.user_id = current_user.id
    if @record.save
      @record.save_tags(tags_array)
      flash[:success] = "登録に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @record = Record.find_by(id: params[:id])
    @tags = @record.tags.pluck(:name).join(",")
  end

  def update
    @record = Record.find_by(id: params[:id])
    tags_array = extract_tags(params[:record][:tags])

    if @record.update(record_params)
      @record.update_tags(tags_array)
      flash[:success] = "書誌情報を更新しました"
      redirect_to records_path
    else
      flash.now[:denger] = "書誌情報の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def create_sample
    sample_records = [
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
    sample_records.each do |record_data|
      tags_array_sample = extract_tags(record_data.delete(:tags))  # タグを配列に変換、レコードデータから不要なtagsキーを削除
      record = current_user.records.create!(record_data)           # レコードを作成
      record.save_tags(tags_array_sample)                          # タグを保存
    end

    flash[:info] = "サンプルデータを追加しました"
    redirect_to records_path
  end

  def destroy
    @record = Record.find_by(id: params[:id])
    @record.destroy
    flash[:success] ="書誌情報を削除しました"
    redirect_to records_path, status: :see_other
  end

  private
    # 要確認：strong paramaterに:tagsを含めておく
    def record_params
      params.require(:record).permit(
        :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
        :compiled_by, :publication_main_title, :publication_sub_title,
        :volume, :no, :volume_other_form, :memo, :type, :status
      )
    end

    def extract_tags(tags_param)
      tags = tags_param.presence || ""
      tags.split(",").map(&:strip)
    end

    def ensure_correct_user
      @record = Record.find_by(id: params[:id])
      if @record.user_id != current_user.id
        flash[:danger] = "権限がありません"
        redirect_to records_path, status: :see_other
      end
    end

    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_url, status: :see_other
      end
    end

    def search_params
      params.permit(:keyword, :tag_name)
    end
end
