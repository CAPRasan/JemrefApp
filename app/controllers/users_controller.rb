class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :show, :edit, :update ]
  before_action :correct_user, only: [ :edit, :update ]
  # def index
  #   @users = User.all
  # end

  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] ="登録に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = "更新に成功しました"
      redirect_to records_path
    else
      flash.now[:danger] = "更新に失敗しました"
      render "edit", status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインが必要です"
      redirect_to login_url, status: :see_other
    end
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to records_path unless current_user?(@user)
  end
end
