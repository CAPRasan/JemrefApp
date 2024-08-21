class RecordsController < ApplicationController
  before_action :authenticatie_user
  before_action :ensure_correct_user, { only: [ :edit, :update, :destroy ] }

  def index
  end

  def edit
    @record = Record.find_by(id: params[:id])
  end

  def create
    @record = Record.new(
      user_id: @current_user.id,
      author_name: params[:author_name],
      main_title: params[:main_title],
      sub_title: params[:sub_title],
      publish_date: params[:publish_date],
      publisher: params[:publisher],
      compiled_by: params[:compiled_by],
      publication: params[:publication],
      volume: params[:volume],
      no: params[:no],
      memo: params[:memo],
      status: params[:status]
    )
    if @record.save
      flash[:notice] = "登録が成功しました"
      redirect_to("/records/new")
    else
      puts "登録に失敗しました"
      puts @record.errors.full_messages
      render("records/new")
    end
  end

  def create_book
    @book = Book.new(
      user_id: @current_user.id,
      author_name: params[:author_name],
      main_title: params[:main_title],
      sub_title: params[:sub_title],
      publish_date: params[:publish_date],
      publisher: params[:publisher],
      compiled_by: params[:compiled_by],
      publication: params[:publication],
      publication_main_title: params[:publication_main_title],
      publication_sub_title: params[:publication_sub_title],
      volume: params[:volume],
      no: params[:no],
      volume_other_form: params[:volume_other_form],
      memo: params[:memo],
      status: params[:status]
    )
    if @book.save
      flash[:notice] = "登録が成功しました"
      redirect_to("/records/new")
    else
      puts "登録に失敗しました"
      puts @book.errors.full_messages
      render("records/new")
    end
  end

  def create_paper
    @paper = Paper.new(
      user_id: @current_user.id,
      author_name: params[:author_name],
      main_title: params[:main_title],
      sub_title: params[:sub_title],
      publish_date: params[:publish_date],
      publisher: params[:publisher],
      compiled_by: params[:compiled_by],
      publication: params[:publication],
      publication_main_title: params[:publication_main_title],
      publication_sub_title: params[:publication_sub_title],
      publication_main_title: params[:publication_main_title],
      publication_sub_title: params[:publication_sub_title],
      volume: params[:volume],
      volume_other_form: params[:volume_other_form],
      no: params[:no],
      memo: params[:memo],
      status: params[:status]
    )
    if @paper.save
      flash[:notice] = "登録が成功しました"
      redirect_to("/records/new")
    else
      puts "登録に失敗しました"
      puts @paper.errors.full_messages
      render("records/new")
    end
  end

  def create_compilation
    @compilation = Compilation.new(
      user_id: @current_user.id,
      author_name: params[:author_name],
      main_title: params[:main_title],
      sub_title: params[:sub_title],
      publish_date: params[:publish_date],
      publisher: params[:publisher],
      compiled_by: params[:compiled_by],
      publication: params[:publication],
      publication_main_title: params[:publication_main_title],
      publication_sub_title: params[:publication_sub_title],
      volume: params[:volume],
      volume_other_form: params[:volume_other_form],
      no: params[:no],
      memo: params[:memo],
      status: params[:status]
    )
    if @compilation.save
      flash[:notice] = "登録が成功しました"
      redirect_to("/records/new")
    else
      puts "登録に失敗しました"
      puts @compilation.errors.full_messages
      render("records/new")
    end
  end

  def update
    @record = Record.find_by(id: params[:id])
    @record.author_name = params[:author_name]
    @record.main_title = params[:main_title]
    @record.sub_title = params[:sub_title]
    @record.publish_date = params[:publish_date]
    @record.publisher = params[:publisher]
    @record.compiled_by = params[:compiled_by]
    @record.publication_main_title = params[:publication_main_title]
    @record.publication_sub_title = params[:publication_sub_title]
    @record.volume = params[:volume]
    @record.no = params[:no]
    @record.volume_other_form = params[:volume_other_form]
    @record.memo = params[:memo]
    @record.status = params[:status]

    if @record.save
      flash[:notice] = "書誌情報を更新しました"
      redirect_to("/records/index")
    else
      flash[:notice] = "書誌情報の更新に失敗しました"
      puts "エラー内容"
      puts @record.errors.full_messages
      render("records/edit")
    end
  end

  def destroy
    @record = Record.find_by(id: params[:id])
    @record.destroy
    flash[:notice] ="書誌情報を削除しました"
    redirect_to("/records/index")
  end

  def ensure_correct_user
    @record = Record.find_by(id: params[:id])
    if @record.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/records/index")
    end
  end
end
