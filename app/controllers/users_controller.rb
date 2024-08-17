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
      flash[:notice] ="登録に成功しました"
      redirect_to("/")
    else
      render("users/new")
    end

  end

  def login_form
  
  end

  def login
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      flash[:notice] ="ログインしました"
      redirect_to("/")
    else
      flash[:notice] ="メールアドレスかパスワードが違います"
      redirect_to("/users/login_form")
    end
  end

end
