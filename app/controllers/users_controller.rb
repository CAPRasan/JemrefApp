class UsersController < ApplicationController
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
      redirect_to("/")
    else
      flash.now[:denger] = "登録に失敗しました"
      puts @user.errors.full_messages
      render :new
    end
    
  end

  def login_form
    
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = "nil"
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

end
