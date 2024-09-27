class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session
      remember user
      log_in user
      flash[:success] = "ログインしました"
      redirect_to records_path, status: :see_other
    else
      flash.now[:danger] = "メールアドレスまたはパスワードが間違っています"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    flash[:success] = "ログアウトしました"
    redirect_to root_url, status: :see_other
  end
end
