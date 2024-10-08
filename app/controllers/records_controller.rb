class RecordsController < ApplicationController
  before_action :logged_in_user
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
    @keyword = search_params[:keyword]
    records = current_user.records.search(@keyword).order(:publish_date)
    @records = records.paginate(page: params[:page], per_page: 20)
  end

  def edit
    @record = Record.find_by(id: params[:id])
  end

  def new
    @record = Record.new
  end

  def create
    @record = Record.new(record_params)
    @record.user_id = current_user.id
    if @record.save
      flash[:success] = "登録に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @record = Record.find_by(id: params[:id])
    if @record.update(record_params)
      flash[:success] = "書誌情報を更新しました"
      redirect_to records_path
    else
      flash.now[:denger] = "書誌情報の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record = Record.find_by(id: params[:id])
    @record.destroy
    flash[:success] ="書誌情報を削除しました"
    redirect_to records_path
  end

  private
    def record_params
      params.require(:record).permit(
        :user_id, :author_name, :main_title, :sub_title, :publish_date, :publisher,
        :compiled_by, :publication_main_title, :publication_sub_title,
        :volume, :no, :volume_other_form, :memo, :type, :status
      )
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
      params.permit(:keyword)
    end
end
