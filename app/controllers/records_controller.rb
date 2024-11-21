class RecordsController < ApplicationController
  include RecordsHelper
  before_action :logged_in_user
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    @q = current_user.records.ransack(search_params)
    # タグ検索がなされた場合
    if params[:tag_name].present?
      @tag_name = params[:tag_name].to_s.strip.downcase # 念の為正規化
      records = Record.tagged_with(@tag_name, current_user)
    # キーワード検索がなされた場合
    else
      records = @q.result(distinct: true)
    end
    @records = records.order(:publish_date)
               .includes(:tags) # タグをロード
               .paginate(page: params[:page], per_page: 20)
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    tags_array = extract_tags(tag_params[:tags]) # 入力したタグ名を受け取る（タグだけテーブルが異なるため）
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
    tags_array = extract_tags(tag_params[:tags])
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
    SampleRecordsCreater.new(current_user).call
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
    def record_params
      params.expect(record: [
        :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
        :compiled_by, :publication_main_title, :publication_sub_title,
        :volume, :no, :volume_other_form, :memo, :type, :status
    ])
    end

    def tag_params
      params.expect(record: [ :tags ])
    end

    # ransack検索用のparams
    # TODO: 検索カラムを切り出し
    def search_params
      if params[:q].present?
        params.require(:q).permit(
          # フリーワード検索
          :author_name_or_main_title_or_sub_title_or_publisher_or_publication_main_title_or_publication_sub_title_or_compiled_by_or_memo_cont,
          # 著者・編者で検索
          :author_name_or_compiled_by_cont,
          # タイトルで検索
          :main_title_or_sub_title_cont,
          # 出版物タイトルで検索
          :publication_main_title_or_publication_sub_title_or_volume_other_form_cont,
          # 出版社で検索
          :publisher_cont,
          # 出版期間で検索
          :publish_date_gteq,
          :publish_date_lteq,
          # 既読・未読・不必要で絞り込み
          :status_eq,
          # メモで検索
          :memo_cont
        )
      else
        {} # params[:q] がない場合、空のハッシュを返す
      end
    end

    # tag検索用のparams処理
    def tag_search_params
      params.permit(:tag_name)
    end

    # 以下、before_action
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
end
