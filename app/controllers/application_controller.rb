class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_current_user
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def authenticatie_user
    if @current_user == nil
      flash[:notice] ="ログインが必要です"
      redirect_to("/login")
    end
  end

  def fobid_login_user
    if @current_user
      flash[:notice] ="すでにログイン済みです"
      redirect_to("/records/new")
    end
  end
end
