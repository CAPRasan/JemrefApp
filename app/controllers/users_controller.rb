class UsersController < ApplicationController
  # before_action :authenticatie_user, { only: [ :logout ] }
  # before_action :fobid_login_user, { only: [ :new, :create, :login, :login_form ] }
  # def index
  #   @users = User.all
  # end

  def show
    @user = User.find_by(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      log_in @user
      flash[:success] ="登録に成功しました"
      redirect_to records_path, status: :see_other
    else
      flash.now[:danger] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
