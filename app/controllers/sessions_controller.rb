class SessionsController < ApplicationController
  before_action :not_logged_in_user, only: [ :new, :create ]
  before_action :logged_in_user, only: [ :destroy ]
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      forwarding_url = session[:forwarding_url]
      reset_session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      log_in @user
      flash[:success] = "ログインしました"
      redirect_to forwarding_url || records_path
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = "ログアウトしました"
    redirect_to root_url, status: :see_other
  end

  private
    def not_logged_in_user
      if logged_in?
        flash[:danger] = "すでにログイン済みです"
        redirect_to records_path, status: :see_other
      end
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "無効な操作です"
        redirect_to root_url
      end
    end
end
