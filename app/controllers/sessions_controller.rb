class SessionsController < ApplicationController
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
end
