class UsersController < ApplicationController
  before_action :authenticatie_user, { only: [ :logout ] }
  before_action :fobid_login_user, { only: [ :new, :create, :login, :login_form ] }
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password]
    )
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] ="登録に成功しました"
      redirect_to("/records/new")
    else
      flash.now[:denger] = "登録に失敗しました"
      puts @user.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/records/new")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render :login, status: :unprocessable_entity
    end
  end

  def logout
    session[:user_id] = "nil"
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
end
