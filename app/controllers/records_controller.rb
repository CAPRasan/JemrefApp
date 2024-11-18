class RecordsController < ApplicationController
  include RecordsHelper
  before_action :logged_in_user
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    # 通常検索とタグ検索は別機能。
    # TODO: strong param設定。
    @q = current_user.records.ransack(search_params)
    @tag_name = tag_params[:tag_name].presence
    # タグ検索の場合。ソート機能は後日実装
    records = if @tag_name.present?
                 Record.tagged_with(@tag_name, current_user).order(:publish_date)
    # 通常検索の場合
    else @q.result(distinct: true).order(:publish_date)
    end
    @records = records.paginate(page: params[:page], per_page: 20)
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
    # ransack検索用のparams
    def search_params
      if params[:q].present?
      params.expect(q: [
        # フリーワード検索
        :author_name_or_main_title_or_sub_title_or_publisher_or_publication_main_title_or_publication_sub_title_or_compiled_by_or_memo_cont,
        # 主題で検索
        :main_title_cont,
        # 人名で検索
        :author_name_or_compiled_by_cont,
        # 既読・未読・不必要で絞り込み
        :status_eq
    ])
      else
        {} # paramsがない場合、空のハッシュを返す
      end
    end

    # tag用のparams処理
    def tag_params
      params.permit(:tag_name)
    end

    # 以下、before action
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
